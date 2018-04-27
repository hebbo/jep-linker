class RemoveShortUrl < ActiveRecord::Migration[5.1]
  def change
    remove_column :links, :short_url, :string
    add_index :links, :long_url, unique: true
  end
end
