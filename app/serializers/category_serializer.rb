class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :updated_at
  # has_many   :sites
end
