class SystemInformationAPI < Grape::API
  format :json

  get '/system/information' do
    present boot_time: Sys::Uptime.boot_time.to_s
  end
end
