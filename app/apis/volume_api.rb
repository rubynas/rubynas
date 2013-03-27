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
      :object_fields => ::VolumeAPI::Volume.documentation
    }
    get '/' do
      present ::Volume.all, with: ::VolumeAPI::Volume
    end
    
    desc "Return the requested volume", {
      :object_fields => ::VolumeAPI::Volume.documentation
    }
    params do
      requires :id, type: Fixnum
    end
    get '/:id' do
      begin
        present ::Volume.find(params[:id]), with: ::VolumeAPI::Volume
      rescue ActiveRecord::RecordNotFound => ex
        throw :error, :status => 404, :messages => ex.message
      end
    end
    
    desc "Update the volume with the passed id"
    put '/:id' do
      begin
        data = { name: params[:name], path: params[:path] }
        ::Volume.find(params.delete(:id)).update_attributes!(data)
      rescue ActiveRecord::RecordNotFound => ex
        throw :error, :status => 404, :messages => ex.message
      end
    end
    
    desc "Create new volume", {
      :object_fields => ::VolumeAPI::Volume.documentation
    }
    post "/" do
      ::Volume.create name: params[:name], path: params[:path]
    end
    
    desc "Delete a volume"
    delete '/:id' do
      begin
        ::Volume.find(params.delete(:id)).destroy
      rescue ActiveRecord::RecordNotFound => ex
        throw :error, :status => 404, :messages => ex.message
      end
    end
  end
end