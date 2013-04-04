require 'factory_girl'

FactoryGirl.define do
  factory :shared_folder_service do
    service_class 'AfpShareService'
    options({ time_machine: true })
    shared_folder
  end
end
