# This file is used by Rack-based servers to start the application.
$LOAD_PATH.unshift(File.expand_path('../lib/', __FILE__))
require 'rubynas'

run Rubynas::Application
