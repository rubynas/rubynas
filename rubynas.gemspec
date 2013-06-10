# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubynas/version'

Gem::Specification.new do |spec|
  spec.name          = "rubynas"
  spec.version       = Rubynas::VERSION
  spec.authors       = ["Vincent Landgraf"]
  spec.email         = ["setcool@gmx.de"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'factory_girl', '~> 4.0'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'brakeman'
  spec.add_development_dependency 'rb-fsevent', '~> 0.9'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-rcov-text'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'database_cleaner'

  # Configuration
  spec.add_runtime_dependency 'inifile'

  # ORM DB
  spec.add_runtime_dependency 'activerecord', '3.2.13'

  # DB
  spec.add_runtime_dependency 'sqlite3'
  
  # Ldap access layer
  spec.add_runtime_dependency 'net-ldap'
  spec.add_runtime_dependency 'activeldap', '~> 3.2.2'

  # AFP / Netatalk
  spec.add_runtime_dependency 'netatalk-config'

  # Service management
  spec.add_runtime_dependency 'foreman'
  spec.add_runtime_dependency 'puma'

  # Middleware API
  spec.add_runtime_dependency 'grape'
  spec.add_runtime_dependency 'grape-entity'

  # System logging
  spec.add_runtime_dependency 'lumberjack'
  spec.add_runtime_dependency 'lumberjack_syslog_device'

  # System information
  spec.add_runtime_dependency 'vmstat'
end
