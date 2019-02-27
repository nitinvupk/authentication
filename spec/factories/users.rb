FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "Foobar@buz" }
    password_confirmation { "Foobar@buz" }
  end
end
