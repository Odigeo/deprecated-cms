class AddIndexToTexts < ActiveRecord::Migration

  def change
    add_index :texts, [:app, :locale]
  end

end
