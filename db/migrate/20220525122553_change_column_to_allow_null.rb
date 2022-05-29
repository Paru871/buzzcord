class ChangeColumnToAllowNull < ActiveRecord::Migration[6.1]
  def up
    change_column :ranks, :author_avatar, :string, null: true
  end

  def down
    change_column :ranks, :author_avatar, :string, null: false
  end
end
