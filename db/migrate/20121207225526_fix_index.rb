class FixIndex < ActiveRecord::Migration
  
  def up
    remove_index "texts", :name => "all_cols"
    add_index    "texts", ["app", "context", "name", "locale"], :unique => true
  end

  def down
    remove_index "texts", ["app", "context", "name", "locale"]
    add_index    "texts", ["app", "context", "locale", "name", "mime_type"], 
                 :name => "all_cols", :unique => true
  end
  
end
