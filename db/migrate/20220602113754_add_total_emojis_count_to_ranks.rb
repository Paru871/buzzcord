class AddTotalEmojisCountToRanks < ActiveRecord::Migration[6.1]
  def change
    add_column :ranks, :total_emojis_count, :integer, null: false
  end
end
