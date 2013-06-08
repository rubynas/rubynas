class DebianInstaller < BaseInstaller
  def prepare_install
    log "Updating the package repository"
    unless sudo_system('apt-get update')
      raise InstallError, "Failed to update the package repository"
    end
  end

  def install(*packages)
    log "Installing #{packages.join(', ')}"
    cmd = "#{sudo} DEBIAN_FRONTEND=noninteractive apt-get install -y " +
          "#{packages.join(' ')}"
    unless sudo_system(cmd)
      raise PackageError, "Failed to install packages #{packages.join(", ")}"
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

    IO.popen("#{sudo} debconf-set-selections", 'w') do |io|
      io.write "'#{category}' '#{key}' #{type} '#{value}'"
    end
    log "Configuring #{category} - #{key}"
    unless $?.exited?
      raise ConfigurationError, "Failed to configure #{category} (#{key})"
    end
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

  def configure_app
    # In the production environment should the root volume always be available
    unless Volume.find_by_name_and_path("System Volume", "/")
      Volume.create(name: "System Volume", path: "/")
    end

    # Setup default account and structure if they don't exist in the repository
    LdapOrgUnit.find_or_create('users')
    LdapOrgUnit.find_or_create('groups')
    LdapUser.find_or_create_admin
    LdapGroup.find_or_create_administrators
  end

  def install_app
    # ruby1.9.1-dev nodejs git-buildpackage git-core ruby-bundler openssl
    # build-essential libreadline6 curl libreadline6-dev git-core zlib1g
    # zlib1g-dev libssl-dev libyaml-dev sqlite3 libxml2-dev autoconf
    # libxslt-dev libc6-dev ncurses-dev automake libtool bison subversion
    # pkg-config libdb-dev libsasl2-dev libxslt-dev libgdbm-dev ncurses-dev
    # libffi-dev ruby1.8-full libqtwebkit-dev debhelper
    install 'ruby1.9.3', 'ruby-bundler', 'libsqlite3-dev'
  end
end
