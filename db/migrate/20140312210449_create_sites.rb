class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :uri
      t.text   :comment
      t.string :policy, default: "production"
      t.timestamps
    end
  end
end
