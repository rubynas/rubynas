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
