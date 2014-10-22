class CorrectIndices < ActiveRecord::Migration

  def change
    remove_index :texts, ["app", "locale"]
    add_index :texts, ["app", "locale", "updated_at"]
 
    remove_index :texts, ["app", "context", "locale"]
    add_index :texts, ["app", "context", "locale", "updated_at"]
  end
end
