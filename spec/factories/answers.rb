FactoryBot.define do
  factory :answer do
    answer { Faker::Lorem.characters(number:5) }
    user
  end
end