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

The vagrant box is setup so that one can test the current application state on the box. To get startet create the box and deploy the application with its services:

    vagrant up

Install build dependencies:

    cap deploy:setup

Install and configure LDAP:

    cap deploy:services

Build and install the service:

	  cap deploy:debian
