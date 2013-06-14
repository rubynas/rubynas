require 'resolv'
require 'foreman'
require 'foreman/cli'

class BaseInstaller
  ROOT_USER_ID = 0

  class InstallError < StandardError; end
  class ConfigurationError < InstallError; end
  class PackageError < InstallError; end

  INSTALL_ORDER = [ :prepare_install, :configure_ldap, :install_ldap,
                    :configure_pam_auth, :install_pam_auth, :configure_app,
                    :install_app ]

  attr_reader :domain, :admin, :password

  # @param [String] domain the domain for the rubynas like 'rubynas.com'
  # @param [String] admin the admin user for the ldap
  # @param [String] password the admin user password
  def initialize(domain, admin, password)
    @domain = domain
    @admin = admin
    @password = password
  end

  # @return [Array<String>] a list of domain parts
  def domain_parts
    @domain_parts ||= Resolv::DNS::Name.create(domain).to_a.map(&:to_s)
  end

  # @return [String]
  def ldap_base
    domain_parts.map { |s| "dc=#{s}" }.join(",")
  end

  # @return [String]
  def admin_ldap_dn
    "cn=#{admin},#{ldap_base}"
  end

  # @return [Boolean] if the current user is root
  def root?
    Process.uid == ROOT_USER_ID
  end

  def log(line)
    STDOUT.puts line
    Rubynas.logger.info "[#{self.class.name}] #{line}"
  end

  # Path to the rubynas executable
  # @return [String]
  def rubynas
    File.expand_path('../../../../bin/rubynas', __FILE__)
  end

  # Executes the installation
  def run
    log "Start install of #{Rubynas::VERSION}"
    INSTALL_ORDER.each do |method|
      send(method) if respond_to? method
    end
  rescue InstallError => ex
    log "Error: #{ex}"
    raise ex
  ensure
    log "Installation ended"
  end
end
