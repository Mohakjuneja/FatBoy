require 'ffaker'

FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    mobile_number { FFaker::PhoneNumber.short_phone_number }
    password "12345678"
    password_confirmation "12345678"    
  end

end
	