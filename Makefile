all: .FORCE
	ruby1.9.3 -S bundle install --deployment --without test development
	ruby1.9.3 -S bundle exec rake assets:clean assets:precompile
	awk '{ print "export " $$1 }' deploy/production.env > deploy/rubynas

clean: .FORCE
	rm -rf .bundle vendor/bundle debs/* public/assets

bundler: .FORCE
	gem install bundler
	bundle install

db_prepare: bundler
	rake db:drop db:migrate db:test:prepare

spec: db_prepare
	rspec spec

debian: .FORCE
	git-dch --ignore-branch --full --since "5a21991e8a83998337dd30ea7e7d82d5cc6cf76b" -S
	dpkg-buildpackage -us -uc
	mkdir -p ~/debs
	mv ../rubynas* ~/debs

security: bundler
	bundle-audit
	brakeman -z

quality: db_prepare
	SIMPLECOV_OUTPUT='txt' rspec spec
	gem install metric_fu
	metric_fu -r
	rake quality

.FORCE: