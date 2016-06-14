FactoryGirl.define do
  factory :subscription do
    association :user, :auth
    provider
    active true
  end
end
