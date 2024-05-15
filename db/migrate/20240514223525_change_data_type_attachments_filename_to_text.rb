class ChangeDataTypeAttachmentsFilenameToText < ActiveRecord::Migration[6.1]
  def up
    change_column :attachments, :attachment_filename, :text
  end

  def down
    change_column :attachments, :attachment_filename, :string
  end
end
