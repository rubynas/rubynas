require 'logger'
require 'inifile'
require 'active_ldap'
require 'active_record'
require 'active_record/errors'
require 'lumberjack'
require 'lumberjack_syslog_device'
require 'netatalk-config'
require 'grape'
require 'grape-entity'
require 'active_support'
require 'active_support/dependencies'
require 'vmstat'

%w(apis models services installers).each do |dir|
  ActiveSupport::Dependencies.autoload_paths.unshift("lib/rubynas/#{dir}")
end

module Rubynas
  class <<self
    attr_accessor :logger
  end

  Application = Rack::Builder.new do
    map "/api" do
      map("/users")   { run ::UserApi }
      map("/groups")  { run ::GroupApi }
      map("/volumes") { run ::VolumeApi }
      map("/system")  { run ::SystemInformationApi }
    end
  end
end

require 'rubynas/config'
