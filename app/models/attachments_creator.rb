# frozen_string_literal: true

class AttachmentsCreator
  def self.call(message, rank_record)
    message_info = JSON.parse(DiscordApiClient.new.fetch_message_info(message))
    return if message_info.blank?

    message_info['attachments'].each do |hash_attachment|
      rank_record.attachments.create do |attachment|
        attachment.attachment_id = hash_attachment['id']
        attachment.attachment_filename = hash_attachment['filename']
      end
    end
  end
end
