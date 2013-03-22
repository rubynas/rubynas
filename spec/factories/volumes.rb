require 'factory_girl'

FactoryGirl.define do
  factory :volume
  
  factory :root_volume, parent: :volume  do
    name "System Volume"
    path "/"
  end
end
