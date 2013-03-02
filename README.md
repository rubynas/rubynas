# RubyNAS

## Getting started

To start developing simply start foreman:

	foreman start

And go to your webbrowser at: 

	http://127.0.0.1:5100/

Login with one of the users in the ldap:

	email: admin@rubynas.com or user@rubynas.com
	password: secret

## Run the tests

Since the tests depend on the LDAP you have to start it first with:

	foreman start

Then use either:

	rake spec
	rake
	rspec spec

## Directories

This project has a typical rails layout plus:

* **debian** for debian deployment
* **deploy** containing system configs and foreman tempalte
* **sandbox** place for local ldap server and the like

## Development & Vagrant

The vagrant box is setup so that one can test the current application state on the box. To get startet create the box and deploy the application:

	vagrant up
	cap deploy:setup

## Debian Package

Install all build dependencies:

	cap deploy:install

Create the package:

	cap deploy:debian

Install the package (the following steps need to be done in the box):

	cd debs
	sudo dpkg -i rubynas*.deb
	sudo restart rubynas

# Dependency installation

## Install OpenLDAP (TODO/WIP)

The applications first dependency is the ldap server for login and authentication:

	sudo apt-get -y install slapd ldap-utils
	sudo dpkg-reconfigure slapd

Use the domain name `rubynas.com` and the organisation name `RubyNAS`.

The password in the `config/ldap.yml` needs to be changed accordingly.

## Install an Nginx in front of RubyNAS

Install the server:

	sudo apt-get -y nginx

Configure the server:

	sudo vi /etc/nginx/sites-available/rubynas

rubynas file content:

	upstream rubynas {
		server 127.0.0.1:5000;
		server 127.0.0.1:5001;
	}
	
	server {
		listen 80;
	
		location ~ ^/(assets)/  {
			root /opt/rubynas/public;
			add_header Cache-Control public;
			gzip_static on; # to serve pre-gzipped version
			expires 1y;
		}
	
		location / {
			proxy_set_header  X-Real-IP $remote_addr;
			proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header  Host $http_host;
			proxy_redirect    off;
			proxy_pass        http://rubynas;
		}
	}

Activate the configuration and disable the default:

	sudo ln -nfs /etc/nginx/sites-available/rubynas /etc/nginx/sites-enabled/rubynas
	sudo rm /etc/nginx/sites-enabled/default

Restart the server:

	sudo /etc/init.d/nginx restart

