# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordApiClient, type: :model do
  context '#fetch_message_info' do
    before do
      @message = [[1_234_567, 11_111], 20]
      stub_request(:get, "#{Discordrb::API.api_base}/channels/#{@message[0][0]}/messages/#{@message[0][1]}").to_return(
        body: { 'attachments': [{ 'id': '98765', 'filename': '1234.jpg' }] }.to_json, status: 200
      )
    end
    it '必要なメッセージ情報が取得できる' do
      response = JSON.parse(DiscordApiClient.new.fetch_message_info(@message))
      expect(response['attachments']).to eq [{ 'filename' => '1234.jpg', 'id' => '98765' }]
    end
  end

  context '#fetch_user_info' do
    before do
      @uid = '1234567'
      stub_request(:get, "#{Discordrb::API.api_base}/users/#{@uid}").to_return(
        body: { "username": 'zzz', "discriminator": '1234', "avatar": 'https://cdn.discordapp.com/embed/avatars/3.png' }.to_json, status: 200
      )
    end
    it '必要なユーザー情報が取得できる' do
      response = JSON.parse(DiscordApiClient.new.fetch_user_info(@uid))
      expect(response['username']).to eq 'zzz'
    end
  end

  context '#make_avatar_url' do
    before do
      @uid = '1234567'
      @avatar_id = '333'
    end
    it 'アバター登録してある場合は必要なアバターURLが取得できる' do
      response = DiscordApiClient.new.make_avatar_url(@uid, @avatar_id)
      expect(response).to eq 'https://cdn.discordapp.com/avatars/1234567/333.webp'
    end
  end

  context '#make_default_avatar' do
    before do
      @discriminator = '1234567'
    end
    it 'アバター未登録の場合はデフォルト画像が取得できる' do
      response = DiscordApiClient.new.make_default_avatar(@discriminator)
      expect(response).to eq 'https://cdn.discordapp.com/embed/avatars/2.png'
    end
  end

  context '#create_post' do
    before do
      @header = 'おはようございます'
      @embed_message = { description: '投稿テスト' }
      @message_url = "#{Discordrb::API.api_base}/channels/#{ENV['DISCORD_CHANNEL_ID']}/messages"
      @stub = stub_request(:post, @message_url).to_return(status: 200, body: { "body": 'おはようございます投稿テスト' }.to_json, headers: {})
    end
    it '投稿を送信できる' do
      response = DiscordApiClient.new.create_post(@header, @embed_message)
      expect(response).to include 'おはようございます投稿テスト'
    end
  end

  context '#fetch_channel_info' do
    before do
      @channel = '1234567'
      stub_request(:get, "#{Discordrb::API.api_base}/channels/#{@channel}").to_return(body: { 'name': 'テストチャンネル' }.to_json, status: 200)
    end
    it '必要なチャンネル情報が取得できる' do
      response = JSON.parse(DiscordApiClient.new.fetch_channel_info(@channel))
      expect(response['name']).to eq 'テストチャンネル'
    end
  end

  context '#fetch_server_member_info' do
    before do
      @uid = '1234567'
      stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{@uid}").to_return(status: 200)
    end
    it 'サーバーのメンバーかどうかを確認する' do
      response = DiscordApiClient.new.fetch_server_member_info(@uid)
      expect(response.code).to eq 200
    end
  end
end
