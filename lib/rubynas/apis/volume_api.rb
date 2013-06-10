class VolumeAPI < Grape::API
  format :json

  rescue_from ActiveRecord::RecordNotFound do |e|
    Rack::Response.new([e.inspect], 404)
  end

  class Volume < Grape::Entity
    expose :id, documentation: { type: String, desc: 'volume unique id' }
    expose :name, documentation: { type: String, desc: 'name of the volume' }
    expose :path, documentation: { type: String, desc: 'path of the volume' }
    expose :capacity, documentation: { type: String, desc: 'capacity in bytes' }
    expose :usage, documentation: { type: Float, desc: 'usage in percent' }
  end

  desc 'Returns the list of volumes', {
    :object_fields => ::VolumeAPI::Volume.documentation
  }
  get '/' do
    present ::Volume.all, with: ::VolumeAPI::Volume
  end

  desc 'Return the requested volume', {
    :object_fields => ::VolumeAPI::Volume.documentation
  }
  params do
    requires :id, type: Fixnum
  end
  get '/:id' do
    present ::Volume.find(params[:id]), with: ::VolumeAPI::Volume
  end

  desc 'Update the volume with the passed id'
  put '/:id' do
    data = { name: params[:name], path: params[:path] }
    ::Volume.find(params.delete(:id)).update_attributes!(data)
  end

  desc 'Create new volume', {
    :object_fields => ::VolumeAPI::Volume.documentation
  }
  post '/' do
    ::Volume.create name: params[:name], path: params[:path]
  end

  desc 'Delete a volume'
  delete '/:id' do
    ::Volume.find(params.delete(:id)).destroy
  end
end