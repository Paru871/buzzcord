class AddPointToReactions < ActiveRecord::Migration[6.1]
  def change
    add_column :reactions, :point, :integer

    remove_column :reactions, :type
  end
end
