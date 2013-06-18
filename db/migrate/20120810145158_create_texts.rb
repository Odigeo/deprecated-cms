class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :app,          limit: 100
      t.string :locale,       limit: 10     # (5 chars x 2 for utf-8)
      t.string :context,      limit: 100
      t.string :name,         limit: 100
      t.string :mime_type,    limit: 100
      t.string :usage,        limit: 100, default: ""
      t.text :result
      t.integer :lock_version, :default => 0, :null => false

      t.timestamps
    end
    add_index :texts, [:app, :context, :locale, :name, :mime_type], :unique => true, :name => "all_cols"
    add_index :texts, :updated_at
  end
end
