class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      t.bigint :channel_id, null: false
      t.bigint :message_id, null: false
      t.bigint :user_id, null: false
      t.string :emoji_name, null: false
      t.bigint :emoji_id
      t.datetime :reacted_at, null: false, index: true
      t.string :type, null: false

      t.timestamps
    end
  end
end
