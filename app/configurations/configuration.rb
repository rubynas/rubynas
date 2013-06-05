class Configuration
  def self.config_file(name = nil)
    @name = name if name
    @name
  end
  
  def shares
    SharedFolder.all
  end
  
  def config
    @path = Rails.root.join("app/config/#{self.class.config_file}.erb")
    ERB.new(File.read(@path)).result(binding)
  end
end
