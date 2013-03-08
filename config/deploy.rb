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
  desc 'Install build dependencies'
  task :building do
    run "sudo apt-get update"
    run "sudo apt-get -y install ruby1.9.3 ruby-bundler libsqlite3-dev " \
      "ruby1.9.1-dev nodejs git-buildpackage git-core ruby-bundler openssl " \
      "build-essential libreadline6 curl libreadline6-dev git-core zlib1g " \
      "zlib1g-dev libssl-dev libyaml-dev sqlite3 libxml2-dev autoconf " \
      "libxslt-dev libc6-dev ncurses-dev automake libtool bison subversion " \
      "pkg-config libdb-dev libsasl2-dev libxslt-dev libgdbm-dev ncurses-dev " \
      "libffi-dev ruby1.8-full libqtwebkit-dev debhelper"
  end
  
  desc 'Create a debian package'
  task :debian do
    run "cd #{deploy_to}/current && make debian"
    hash = `git log -1 --format=oneline`[0...6]
    run "cd debs && sudo dpkg -i rubynas*#{hash}*.deb"
    run "sudo apt-get install -fy"
	  run "sudo restart rubynas"
    run "sudo /etc/init.d/nginx restart"
  end
  
  desc 'Configure the remote system to use a ldap for authentication'
  task :services do
    config = File.read(__FILE__).split("__END__").last
    config_file = "/tmp/service.conf"
    put config, config_file
    run "sudo debconf-set-selections < #{config_file}"
    run "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y " \
        "ldap-utils libnss-ldapd libpam-ldapd nslcd slapd nginx"
  end
end

before "deploy:debian", "deploy"
before "deploy:setup", "deploy:building"


__END__
# LDAP Configuration
slapd slapd/internal/generated_adminpw password secret
slapd slapd/password2 password secret
slapd slapd/internal/adminpw password secret
slapd slapd/password1 password secret
slapd slapd/allow_ldap_v2 boolean true
slapd slapd/invalid_config boolean true
slapd shared/organization string RubyNAS
slapd slapd/no_configuration boolean false
slapd slapd/move_old_database boolean true
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/purge_database boolean true
slapd slapd/domain string rubynas.com
slapd slapd/backend string HDB

# Use LDAP for authentication
libnss-ldapd libnss-ldapd/nsswitch multiselect passwd, group, shadow 
libpam-ldapd libpam-ldapd/enable_shadow boolean true
libnss-ldapd libnss-ldapd/clean_nsswitch boolean false

# Setup the auth daemon with the ldap server
nslcd nslcd/ldap-starttls boolean false
nslcd nslcd/ldap-sasl-krb5-ccname string /var/run/nslcd/nslcd.tkt
nslcd nslcd/ldap-auth-type select none
nslcd nslcd/ldap-uris string ldapi:///
nslcd nslcd/ldap-base string dc=rubynas,dc=com
nslcd nslcd/ldap-binddn string cn=admin,dc=rubynas,dc=com
nslcd nslcd/ldap-bindpw password secret
