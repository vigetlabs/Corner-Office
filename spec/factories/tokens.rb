FactoryGirl.define do
  factory :token do
    user
    secret "access_token"
  end
end
