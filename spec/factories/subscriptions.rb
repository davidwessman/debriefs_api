FactoryGirl.define do
  factory :subscription do
    user
    provider
    active true
  end
end
