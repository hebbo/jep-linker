class AddIsCustomUrlToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :is_custom_url, :boolean, default: false
  end
end
