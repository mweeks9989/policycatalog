class AddCreatedByToSite < ActiveRecord::Migration
  def change
    add_column :sites, :created_by, :string
  end
end
