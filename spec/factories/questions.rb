FactoryBot.define do
  factory :question do
    title { Faker::Lorem.characters(number:5) }
    body { Faker::Lorem.characters(number:20) }
    user
  end
end