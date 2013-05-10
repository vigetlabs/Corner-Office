FactoryGirl.define do
  sequence(:email) { |n| "user-#{n}@example.com" }

  factory :user do
    first_name "John"
    last_name "Smith"
    email
    password "a-secure-password"
    password_confirmation "a-secure-password"
    site "https://vigetdevs.highrisehq.com/"
  end
end
