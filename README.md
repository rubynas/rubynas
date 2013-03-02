# RubyNAS

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
