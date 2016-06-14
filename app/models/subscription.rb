class Subscription < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :provider, required: true
end
