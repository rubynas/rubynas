module Rubynas
  class Config
    # @param [String] path the path to the configuration
    def self.use(path)
      new(path).configure
    end

    def initialize(path)
      @path = path
      @ini = IniFile.load(path, :encoding => 'utf-8')
    end

    def configure
      configure_logger
      configure_active_ldap
      configure_active_record
    end

    def configure_logger
      section = @ini['Server']
      if section['syslog'] == 'true'
        facility = Syslog::LOG_LOCAL0 | Syslog::LOG_CONS
        device = Lumberjack::SyslogDevice.new facility: facility
        Rubynas.logger = Lumberjack::Logger.new device, progname: "rubynas"
      else
        Rubynas.logger = Logger.new(STDOUT)
      end
    end

    def configure_active_record
      section = @ini['Database']
      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => section['path'],
        :timeout => (section['timeout'] || 5000).to_i,
        :pool => (section['pool'] || 5).to_i
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
end

# Regular usage
if File.exist?('/etc/rubynas.ini')
  Rubynas::Config.use('/etc/rubynas.ini')

# Local testing usage
elsif File.exist?('rubynas.ini')
  Rubynas::Config.use('rubynas.ini')
end