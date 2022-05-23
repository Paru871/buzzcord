class CreateRanks < ActiveRecord::Migration[6.1]
  def change
    create_table :ranks do |t|
      t.integer :order, null: false, default: 0, index: true
      t.bigint :channel_id, null: false
      t.string :channel_name, null: false
      t.bigint :thread_id
      t.string :thread_name
      t.bigint :message_id, null: false
      t.text :content, null: false
      t.bigint :author_id, null: false
      t.string :author_name, null: false
      t.string :author_avatar, null: false
      t.string :author_discriminator, null: false

      t.timestamps
    end
  end
end
