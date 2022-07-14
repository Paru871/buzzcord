# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostBuzzcord, type: :model do
  describe '#post' do
    before do
      @message_url = "#{Discordrb::API.api_base}/channels/#{ENV['DISCORD_CHANNEL_ID']}/messages"
    end

    context 'ランキング1位の発言がスレッド内だったとき' do
      before do
        @rank = create(:rank)
        @attachment = create(:attachment, rank_id: @rank.id)
        @stub = stub_request(:post, @message_url).with(body: hash_including(message_hash_thread))
      end
      it 'スレッド名を含んだ投稿が正常に送信される' do
        formatter = BotMessageFormatter.new
        PostBuzzcord.post(formatter)
        expect(@stub).to have_requested(:post, @message_url)
      end
    end

    context 'ランキング1位の発言がチャンネル内だったとき' do
      before do
        @rank = create(:rank, thread_id: nil)
        @attachment = create(:attachment, rank_id: @rank.id)
        @stub = stub_request(:post, @message_url).with(body: hash_including(message_hash_channel))
      end
      it 'チャンネル名のみの投稿が正常に送信される' do
        formatter = BotMessageFormatter.new
        PostBuzzcord.post(formatter)
        expect(@stub).to have_requested(:post, @message_url)
      end
    end

    context 'リアクションがなかったとき' do
      before do
        @stub = stub_request(:post, @message_url).with(body: hash_including(reaction_zero_hash))
        @rank = nil
      end
      it 'リアクション0のお知らせ投稿が正常に送信される' do
        formatter = BotMessageFormatter.new
        PostBuzzcord.post(formatter)
        expect(@stub).to have_requested(:post, @message_url)
      end
    end

    def message_hash_thread
      {
        content: "おはようございます😃\n昨日バズった発言の第1位は…\n「#{@rank.channel_name}チャンネル、#{@rank.thread_name}スレッド」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{@rank.thread_id}/#{@rank.message_id}"
      }
    end

    def message_hash_channel
      {
        content: "おはようございます😃\n昨日バズった発言の第1位は…\n「#{@rank.channel_name}チャンネル」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{@rank.channel_id}/#{@rank.message_id}"
      }
    end

    def reaction_zero_hash
      {
        content: "おはようございます😃\n昨日はスタンプのリアクションはありませんでした。\n素敵な1日をお過ごしください。"
      }
    end
  end
end
