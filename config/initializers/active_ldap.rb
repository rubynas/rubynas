ActiveLdap::Base.setup_connection(
  :host => '127.0.0.1',
  :port => (Rails.env.production? ? 389 : 10389),
  :base => 'dc=rubynas,dc=com',
  :logger => Rails.logger,
  :bind_dn => "cn=admin,dc=rubynas,dc=com",
  :password_block => Proc.new { 'secret' },
  :allow_anonymous => false,
  :try_sasl => false
)
