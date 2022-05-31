class AddPostedAtToRanks < ActiveRecord::Migration[6.1]
  def change
    add_column :ranks, :posted_at, :datetime, null: false
  end
end
