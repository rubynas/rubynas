require 'resolv'

class BaseInstaller
  ROOT_USER_ID = 0
  
  class InstallError < StandardError; end
  class ConfigurationError < InstallError; end
  class PackageError < InstallError; end
  
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
  
  # Calls the passed the system function as root
  # @param [String] cmd the command to execute
  def sudo_system(cmd)
    system("#{sudo} #{cmd}".strip)
  end

  # @return [String] if user is root will return sudo string
  def sudo
    'sudo' unless root?
  end

  # @return [Boolean] if the current user is root
  def root?
    Process.uid == ROOT_USER_ID
  end
end
