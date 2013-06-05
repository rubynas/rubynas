require 'factory_girl'

FactoryGirl.define do
  factory :shared_folder do
    name "System"
    path "/"
  end
  
  factory :shared_folder_with_services, parent: :shared_folder do
    after(:create) do |shared_folder, evaluator|
      shared_folder << build(:shared_folder_service)
      shared_folder.save
    end
  end
end
