require 'etc'
require 'tempfile'
require 'fileutils'

class DebianInstaller < BaseInstaller
  include FileUtils

  def prepare_install
    log "Updating the package repository"
    unless system('apt-get update')
      raise InstallError, "Failed to update the package repository"
    end
  end

  def install(*packages)
    log "Installing #{packages.join(', ')}"
    ENV['DEBIAN_FRONTEND'] = 'noninteractive'
    unless system("apt-get install -y #{packages.join(' ')}")
      raise PackageError, "Failed to install packages #{packages.join(", ")}"
    end
  end

  def restart_service(service)
    log "Start service rubynas"
    unless system('service rubynas restart')
      raise InstallError, "Failed to start service"
    end
  end

  def debconf(category, key, type, value)
    case type
    when :password, :string, :select
      value = value.to_s
    when :boolean
      value = value ? true : false
    when :multiselect
      value = value.join(', ')
    end

    IO.popen("debconf-set-selections", 'w') do |io|
      io.write "'#{category}' '#{key}' #{type} '#{value}'"
    end
    log "Configuring #{category} - #{key}"
    unless $?.exited?
      raise ConfigurationError, "Failed to configure #{category} (#{key})"
    end
  end

  # Returns the ruby executable
  def ruby
    "ruby1.9.3 -S"
  end

  def configure_ldap
    log 'Configure LDAP'
    debconf 'slapd', 'slapd/internal/generated_adminpw', :password, @password
    debconf 'slapd', 'slapd/password2', :password, @password
    debconf 'slapd', 'slapd/internal/adminpw', :password, @password
    debconf 'slapd', 'slapd/password1', :password, @password
    debconf 'slapd', 'slapd/allow_ldap_v2', :boolean, true
    debconf 'slapd', 'slapd/invalid_config', :boolean, true
    debconf 'slapd', 'shared/organization', :string, @domain
    debconf 'slapd', 'slapd/no_configuration', :boolean, false
    debconf 'slapd', 'slapd/move_old_database', :boolean, true
    debconf 'slapd', 'slapd/dump_database_destdir', :string,
                     '/var/backups/slapd-VERSION'
    debconf 'slapd', 'slapd/purge_database', :boolean, true
    debconf 'slapd', 'slapd/domain', :string, @domain
    debconf 'slapd', 'slapd/backend', :string, 'HDB'
  end

  def install_ldap
    install 'ldap-utils', 'slapd'
  end

  def configure_pam_auth
    log 'Configure ldap with pam (authentication)'
    debconf 'libnss-ldapd', 'libnss-ldapd/nsswitch', :multiselect,
            [:passwd, :group, :shadow]
    debconf 'libpam-ldapd', 'libpam-ldapd/enable_shadow', :boolean, true
    debconf 'libnss-ldapd', 'libnss-ldapd/clean_nsswitch', :boolean, false

    log 'Configure the authentication daemon for ldap and pam auth'
    debconf 'nslcd', 'nslcd/ldap-starttls', :boolean, false
    debconf 'nslcd', 'nslcd/ldap-sasl-krb5-ccname', :string,
                     '/var/run/nslcd/nslcd.tkt'
    debconf 'nslcd', 'nslcd/ldap-auth-type', :select, 'none'
    debconf 'nslcd', 'nslcd/ldap-uris', :string, 'ldapi:///'
    debconf 'nslcd', 'nslcd/ldap-base', :string, ldap_base
    debconf 'nslcd', 'nslcd/ldap-binddn', :string, admin_ldap_dn
    debconf 'nslcd', 'nslcd/ldap-bindpw', :password, @password
  end

  def install_pam_auth
    install 'libnss-ldapd', 'libpam-ldapd', 'nslcd'
  end

  def install_app
    create_rubynas_user
    create_directories
    create_configuration
    create_upstart_script
    migrate_database
    restart_service :rubynas
  end

private

  def create_rubynas_user
    begin
      Etc.getpwnam('rubynas')
    rescue ArgumentError => ex
      log "Create rubynas user"
      system 'useradd rubynas --system --no-create-home'
    end
  end

  def create_directories
    log "Create directories"
    mkdir_p '/var/lib/rubynas/'
  end

  def create_configuration
    if File.exist? '/etc/rubynas.ini'
      log "The configuration rubynas.ini already exist!"
    else
      log "Create rubynas.ini"
      File.open('/etc/rubynas.ini', 'w') do |f|
        config = <<-CONF
          ;
          ; This is the configuration file for local development and testing.
          ;

          ; Configuration for the sqlite3 database
          [Database]
          path = %s
          timeout = 5000
          pool = 5

          ; Configuration for the ldap server that is used for authentication,
          ; user and group management
          [Ldap]
          host = 127.0.0.1
          port = 389
          base = "%s"
          bind_dn = "%s"
          password = %s

          ; Server related configuration
          [Server]
          ; if syslog set to false it will be logged to stdout
          syslog = true
          ; NOTHING HERE YET
        CONF
        f.puts config.gsub(/^\s+/, "") % [
          db_path,
          ldap_base,
          admin_ldap_dn,
          password
        ]
      end
    end
  end

  def create_upstart_script
    # Create a rubynas upstart script
    Tempfile.open('env') do |fe|
      %w(GEM_HOME GEM_PATH PATH).each do |name|
        fe.puts "#{name}=#{ENV[name]}" if ENV[name]
      end
      fe.flush

      Tempfile.open('Procfile') do |fp|
        fp.puts "api: exec #{ruby} #{rubynas} server"
        fp.close

        Foreman::CLI.start [
          'export', '--app', 'rubynas', '--env', fe.path,
          '--procfile', fp.path, 'upstart', '/etc/init'
        ]
      end
    end
  end

  def migrate_database
    log "Migrate the database"
    unless system("#{ruby} #{rubynas} migrate")
      raise InstallError, "Failed to migrate the database"
    end

    log "Allow access to database by rubynas user"
    user = Etc.getpwnam('rubynas')
    chown user.uid, user.gid, db_path
  end

  def db_path
    '/var/lib/rubynas/sqlite3.db'
  end
end
