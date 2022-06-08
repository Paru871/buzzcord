class AddContentPostToRanks < ActiveRecord::Migration[6.1]
  def change
    add_column :ranks, :content_post, :string
  end
end
