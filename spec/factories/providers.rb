FactoryGirl.define do
  factory :provider do
    title FFaker::Company.name
    url FFaker::Internet.http_url
    active false
    description FFaker::Company.catch_phrase
  end
end
