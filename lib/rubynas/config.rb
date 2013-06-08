require 'inifile'
require 'active_ldap'
require 'active_record'

class Rubynas::Config
  # @param [String] path the path to the configuration
  def self.use(path)
    new(path).configure
  end
  
  def initialize(path)
    @path = path
    @ini = IniFile.load(path, :encoding => 'utf-8')
  end
  
  def configure
    configure_active_ldap
    configure_active_record
  end
  
  def configure_active_record
    section = @ini['Database']
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => section['path'],
      :timeout => section['timeout'] || 5000,
      :pool => section['pool'] || 5
    )
  end
  
  def configure_active_ldap
    section = @ini['Ldap']
    ActiveLdap::Base.setup_connection(
      :host => section['host'],
      :port => section['port'],
      :base => section['base'],
      :logger => Rubynas.logger,
      :bind_dn => section['bind_dn'],
      :password_block => Proc.new { section['password'] },
      :allow_anonymous => false,
      :try_sasl => false
    )
  end
end

# Regular usage
Rubynas::Config.use('/etc/rubynas.ini') if File.exist?('/etc/rubynas.ini')

# Local testing usage
Rubynas::Config.use('rubynas.ini') if File.exist?('rubynas.ini')
