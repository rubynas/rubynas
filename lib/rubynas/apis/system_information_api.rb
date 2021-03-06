class SystemInformationApi < Grape::API
  format :json

  desc 'resturns vmstat data'
  get '/vmstat' do
    present Vmstat.snapshot
  end

  desc 'returns disk related information'
  get '/disk' do
    present Vmstat.disk('/' + params[:path].to_s)
  end

  desc 'returns the hostname'
  get '/hostname' do
    present Socket.gethostname
  end
end
