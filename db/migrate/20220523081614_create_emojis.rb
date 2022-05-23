class CreateEmojis < ActiveRecord::Migration[6.1]
  def change
    create_table :emojis do |t|
      t.references :rank, null: false, index: true, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.string :emoji_name, null: false
      t.bigint :emoji_id
      t.integer :count, null: false, default: 0

      t.timestamps
    end
  end
end
