class ProviderSerializer < ActiveModel::Serializer
  attributes(:id, :title, :url, :active, :description, :created_at, :updated_at)
end
