desc "Create a secret file"
task "secret:file" do
  require 'securerandom'
  path = "config/initializers/secret_token.rb"
  secret = SecureRandom.hex(64)
  unless File.exists?(path)
    File.open(path, "w") do |f|
      f.puts "SupportPortal::Application.config.secret_token = '#{secret}'"
    end
  end
end
