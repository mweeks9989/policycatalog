class Category < ActiveRecord::Base
  attr_readonly :name, :description

  validates :name,        presence: true, uniqueness: true
  validates :description, presence: true

  has_many :categorizations
  has_many :sites, through: :categorizations

  def to_param
    name
  end
end
