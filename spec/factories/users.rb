require 'factory_girl'

FactoryGirl.define do
  factory :user do
    email 'test@rubynas.com'
    password 'secret123'
  end
end
