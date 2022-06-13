# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BotMessageFormatter, type: :model do
  describe '#header' do
    context 'ランキング1位の発言がスレッド内だったとき' do
      before do
        @rank = create(:rank)
        @attachment = create(:attachment, rank_id: @rank.id)
      end
      it 'スレッド名を含んだヘッダーが選択される' do
        formatter = BotMessageFormatter.new
        expect(formatter.header).to eq 
      end
    end

    context 'ランキング1位の発言がチャンネル内だったとき' do
      before do
        @rank = create(:rank)
        @attachment = create(:attachment, rank_id: @rank.id)
        @stub = stub_request(:post, @message_url).with(body: hash_including(message_hash_channel))
      end
      xit 'チャンネル名のみの投稿が正常に送信される' do
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
    # rubocop:disable Layout/LineLength, Metrics/MethodLength
    def message_hash_thread
      {
        content: "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{@rank.channel_name}チャンネル、#{@rank.thread_name}スレッド」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:"
      }
    end

    def message_hash_channel
      {
        content: "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{@rank.channel_name}チャンネル」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:"
      }
    end

    def reaction_zero_hash
      {
        content: "おはようございます😃Buzzcordお知らせbotです。\n昨日このDiscordサーバー内では、絵文字スタンプの反応がありませんでした。\n素敵な1日をお過ごしください👍"
      }
    end
    # rubocop:enable Layout/LineLength, Metrics/MethodLength
  end
end
