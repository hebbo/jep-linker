class AddShortUrlToLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :links, :short_url, :string
    add_index :links, :short_url, unique: true
  end
end
