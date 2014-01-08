class ImproveMainIndex < ActiveRecord::Migration

  def up
    add_index    "texts", ["app", "context", "locale", "name"], unique: true, name: "main_index"
    remove_index "texts", ["app", "context", "name", "locale"]
  end

  def down
    add_index    "texts", ["app", "context", "name", "locale"], unique: true
    remove_index "texts", name: "main_index"
  end

end
