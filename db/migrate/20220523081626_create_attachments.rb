class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.references :rank, null: false, index: true, foreign_key: { on_delete: :cascade, on_update: :cascade }
      t.bigint :attachment_id
      t.string :attachment_filename

      t.timestamps
    end
  end
end
