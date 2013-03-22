class VolumeAPI < Grape::API
  format :json
  
  class Volume < Grape::Entity
    expose :id, :documentation => { :type => String, :desc => "volume unique id" }
    expose :name, :documentation => { :type => String, :desc => "name of the volume" }
    expose :path, :documentation => { :type => String, :desc => "path of the volume" }
    expose :capacity, :documentation => { :type => String, :desc => "capacity in bytes" }
    expose :usage, :documentation => { :type => Float, :desc => "usage in percent" }
  end
  
  resource :volumes do
    desc "Returns the list of volumes", {
      :object_fields => VolumeAPI::Volume.documentation
    }
    get '/' do
      present ::Volume.all, with: VolumeAPI::Volume
    end
  end
end