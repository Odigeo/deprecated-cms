class AddCreatedByAndUpdatedBy < ActiveRecord::Migration

  def change
  	add_column :texts, :created_by, :integer
  	add_column :texts, :updated_by, :integer
  end

end
