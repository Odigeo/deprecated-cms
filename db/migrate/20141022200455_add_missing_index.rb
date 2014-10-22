class AddMissingIndex < ActiveRecord::Migration
  def change
    add_index :texts, ["app", "context", "locale"]
  end
end
