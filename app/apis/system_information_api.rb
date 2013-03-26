class SystemInformationAPI < Grape::API
  format :json
  
  desc 'resturns vmstat data'
  get '/system/vmstat' do
    present Vmstat.snapshot
  end
  
  desc 'returns disk related information'
  get '/system/disk' do
    present Vmstat.disk("/" + params[:path].to_s)
  end
end
