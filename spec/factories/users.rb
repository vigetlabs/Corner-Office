FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Smith"
    email "john.smith@testing.com"
    password "a-secure-password"
    password_confirmation "a-secure-password"
  end
end
