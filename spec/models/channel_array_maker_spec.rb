# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsCreator, type: :model do
  describe '#call' do
    context 'スレッド内の投稿のとき' do
      before do
        @message = [[1_234_567, 11_111], 20]
        @channel = @message[0][0]
        stub_request(:get, "#{Discordrb::API.api_base}/channels/1234567").to_return(
          body: { 'name': 'テストスレッド', 'thread_metadata': '123', 'parent_id': 55_555 }.to_json, status: 200
        )
        stub_request(:get, "#{Discordrb::API.api_base}/channels/55555").to_return(body: { 'name': 'テストチャンネル' }.to_json, status: 200)
      end
      it '親チャンネル情報を取得して配列に格納する' do
        channel_array = ChannelArrayMaker.call(@message)
        expect(channel_array).to eq [1_234_567, 'テストスレッド', 55_555, 'テストチャンネル']
      end
    end

    context 'チャンネル内の投稿のとき' do
      before do
        @message = [[1_234_567, 11_111], 20]
        @channel = @message[0][0]
        stub_request(:get, "#{Discordrb::API.api_base}/channels/#{@channel}").to_return(body: { 'name': 'テストチャンネル' }.to_json, status: 200)
      end
      it 'そのまま配列に格納する' do
        channel_array = ChannelArrayMaker.call(@message)
        expect(channel_array).to eq [nil, nil, 1_234_567, 'テストチャンネル']
      end
    end
  end
end
