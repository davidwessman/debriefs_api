class SubscriptionSerializer < ActiveModel::Serializer
  attributes(:id, :active)
  has_one(:user)
  has_one(:provider)
end
