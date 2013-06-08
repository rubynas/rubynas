# encoding: utf-8
require 'simplecov'
SimpleCov.start do
  add_group 'API',        'lib/rubynas/apis'
  add_group 'DB',         'lib/rubynas/db'
  add_group 'Installers', 'lib/rubynas/installers'
  add_group 'Models',     'lib/rubynas/models'
  add_group 'Services',   'lib/rubynas/services'
  add_filter '/spec/'
end

$LOAD_PATH.unshift(File.expand_path('../../lib/', __FILE__))
require 'rubynas'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  # In RSpec 3, these symbols will be treated as metadata keys with
  # a value of `true`.  To get this behavior now (and prevent this
  # warning), you can set a configuration option:
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
