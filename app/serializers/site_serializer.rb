class SiteSerializer < ActiveModel::Serializer
  attributes :id, :uri, :comment, :policy, :created_by, :created_at, :updated_at
  has_many   :categories
end
