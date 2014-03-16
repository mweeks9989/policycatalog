class Categorization < ActiveRecord::Base
  MAX_CATEGORIES_PER_SITE=5
  attr_readonly :category_id, :site_id
  
  belongs_to :category
  belongs_to :site
 
  validates :site_id, uniqueness: { 
    scope:   :category_id, 
    message: "cannot be included in the same category more than once" 
  }
  
  validate :on => :create do
    if site.categorizations.size >= MAX_CATEGORIES_PER_SITE
      errors.add :site_id, "can only be a member of #{MAX_CATEGORIES_PER_SITE} categories. Please remove one or add a different site."
    end
  end
end
