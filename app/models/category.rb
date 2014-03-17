class Category < ActiveRecord::Base
  attr_readonly :name, :description

  validates :name,        presence: true, uniqueness: true
  validates :description, presence: true

  has_many :categorizations
  has_many :sites, through: :categorizations

  def to_param
    name
  end

  def fetch_associated(item)
    case item
      when Site
        item
      when String
        Site.find_by_uri(item)
      else
        nil
    end
  end

  def add(*items)
    items.each do |item|
      to_add=fetch_associated(item)
      begin
        self.sites << to_add
      rescue ActiveRecord::RecordInvalid => exception
        self.errors.add(:base, sprintf("%s: %s", to_add.uri, exception.message))
      rescue ActiveRecord::AssociationTypeMismatch => exception
        self.errors.add(:base, sprintf("%s: %s", item, "invalid uri, or site not in database"))
      end
    end
    self
  end
  def remove(*items)
  end
end
