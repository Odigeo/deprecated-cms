class AddIndexOnCreatedAt < ActiveRecord::Migration

  def change
    add_index :texts, [:created_at]
  end

end
