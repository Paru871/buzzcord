# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RanksCreator, type: :model do
  describe '#call' do
    context 'Rankレコードが正確に作成される' do
      it 'Rankレコードが1件作成される' do
        message = [[1_234_567, 11_111], 20]
        index = 1
        regist_stub(message)
        expect { RanksCreator.call(message, index) }
          .to change { Rank.count }.from(0).to(1)
      end
    end
  end

  def regist_stub(message)
    stub_request(:get, "#{Discordrb::API.api_base}/channels/#{message[0][0]}/messages/#{message[0][1]}").to_return(
      body: { 'content': 'testです！', 'author': { 'id': '1234567', 'username': 'Mock', 'avatar': '99999', 'discriminator': '1234' },
              'timestamp': '2022-06-12T15:50:46.847000+00:00' }.to_json, status: 200
    )

    stub_request(:get, "#{Discordrb::API.api_base}/channels/#{message[0][0]}").to_return(body: { 'name': 'テストチャンネル' }.to_json, status: 200)
  end
end
