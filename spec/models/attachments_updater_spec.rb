# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsUpdater, type: :model do
  context '#attachments_update' do
    it '正確な数のAttachmentsレコードが作成される' do
      rank_record = create(:rank)
      message = [[1_234_567, 11_111], 20]
      regist_stub(message)
      expect(Attachment.count).to eq 0
      AttachmentsUpdater.new.create_attachments(message, rank_record)
      expect(Attachment.count).to eq 1
    end
  end

  def regist_stub(message)
    stub_request(:get, "#{Discordrb::API.api_base}/channels/#{message[0][0]}/messages/#{message[0][1]}").to_return(
      body: { "attachments": [{ "id": '98765', "filename": '1234.jpg' }] }.to_json, status: 200
    )
  end
end
