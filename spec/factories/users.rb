FactoryBot.define do
  factory :user do
    first_name 'John'
    last_name 'Smith'
    user_name 'jsmith'
    password 'Password'
    avatar 'gsdfgsdfg'

    sequence(:email) { |n| "cbog#{n}@gmail.com" }
  end
end
