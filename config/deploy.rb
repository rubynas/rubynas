set :application, "rubynas"
set :repository,  "."
set :scm, :none
set :user, 'vagrant'
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy
set :use_sudo, false
set :password, 'vagrant'

role :web, "192.168.33.20"

namespace :deploy do
  desc 'Create a debian package'
  task :debian do
    run "cd #{deploy_to}/current && make debian"
    hash = `git log -1 --format=oneline`[0...6]
    run "cd debs && sudo dpkg -i rubynas*#{hash}*.deb"
    run "sudo apt-get install -fy"
	  run "sudo restart rubynas"
  end
  
  desc 'Install build dependencies'
  task :install do
    run "sudo apt-get update"
    run "sudo apt-get -y install ruby1.9.3 ruby-bundler libsqlite3-dev " \
      "ruby1.9.1-dev nodejs git-buildpackage git-core ruby-bundler openssl " \
      "build-essential libreadline6 curl libreadline6-dev git-core zlib1g " \
      "zlib1g-dev libssl-dev libyaml-dev sqlite3 libxml2-dev autoconf " \
      "libxslt-dev libc6-dev ncurses-dev automake libtool bison subversion " \
      "pkg-config libdb-dev libsasl2-dev libxslt-dev libgdbm-dev ncurses-dev " \
      "libffi-dev ruby1.8-full libqtwebkit-dev debhelper"
  end
end

before "deploy:debian", "deploy"
before "deploy:setup", "deploy:install"
