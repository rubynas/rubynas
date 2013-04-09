desc 'Development environment dependencies'
task 'dev:dependencies' do
  dependencies = {
    ldap:      '/usr/libexec/slapd -V',
    phantomjs: 'phantomjs -v'
  }

  puts 'Checking dependencies...'
  dependencies.each do |name, command|
    puts "--- #{name} ---"
    puts `#{command}`
  end
end
