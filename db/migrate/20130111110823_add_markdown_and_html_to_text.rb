class AddMarkdownAndHtmlToText < ActiveRecord::Migration

  def change
  	add_column :texts, :markdown, :boolean,  null: false, default: false
  	add_column :texts, :html,     :text,     null: true,  default: nil
  end

end
