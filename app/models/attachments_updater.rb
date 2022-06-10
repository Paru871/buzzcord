# frozen_string_literal: true

class AttachmentsUpdater
  def create_attachments(message_info, rank_record)
    message_info['attachments'].each do |hash_attachment|
      rank_record.attachments.create do |attachment|
        attachment.attachment_id = hash_attachment['id']
        attachment.attachment_filename = hash_attachment['filename']
      end
    end
  end
end
