# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BotMessageFormatter, type: :model do
  describe '#header' do
    context 'ランキング1位の発言がスレッド内だったとき' do
      before do
        @rank = create(:rank)
        @attachment = create(:attachment, rank_id: @rank.id)
      end
      it 'スレッド名を含んだヘッダーが作成される' do
        formatter = BotMessageFormatter.new
        expect(formatter.header).to eq message_header_thread
      end
    end

    context 'ランキング1位の発言がチャンネル内だったとき' do
      before do
        @rank = create(:rank, thread_id: nil)
        @attachment = create(:attachment, rank_id: @rank.id)
      end
      it 'チャンネル名のみのヘッダーが作成される' do
        formatter = BotMessageFormatter.new
        expect(formatter.header).to eq message_header_channel
      end
    end

    context 'リアクションがなかったとき' do
      before do
        @rank = nil
      end
      it 'リアクション0のお知らせヘッダーが作成される' do
        formatter = BotMessageFormatter.new
        expect(formatter.header).to eq reaction_zero_header
      end
    end
  end

  describe '#embed_message' do
    context 'ランキング1位があるとき' do
      before do
        @rank = create(:rank)
        @attachment = create(:attachment, rank_id: @rank.id)
      end
      it 'ランキング1位情報が作成される' do
        formatter = BotMessageFormatter.new
        expect(formatter.embed_message).to eq message_embed_hash
      end
    end

    context 'ランキングがないとき' do
      before do
        @rank = nil
      end
      it '何も作成されない' do
        formatter = BotMessageFormatter.new
        expect(formatter.embed_message).to eq nil
      end
    end

    context 'ランキング1位に添付画像があるとき' do
      before do
        @rank = create(:rank)
        @attachment = create(:attachment, rank_id: @rank.id)
      end
      it 'ランキング1位情報に添付画像情報が付加される' do
        formatter = BotMessageFormatter.new
        expect(formatter.embed_message).to eq message_embed_hash
      end
    end

    context 'ランキング1位に添付画像がないとき' do
      before do
        @rank = create(:rank)
      end
      it 'ランキング1位情報に添付画像情報が付加されない' do
        formatter = BotMessageFormatter.new
        expect(formatter.embed_message).to eq message_embed_hash_no_attachment
      end
    end
  end

  # rubocop:disable Metrics/MethodLength
  def message_header_thread
    "おはようございます😃\n昨日バズった発言の第1位は…\n「趣味の広場チャンネル、音楽スレッド」での<@45678>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/23456/34567"
  end

  def message_header_channel
    "おはようございます😃\n昨日バズった発言の第1位は…\n「趣味の広場チャンネル」での<@45678>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/12345/34567"
  end

  def reaction_zero_header
    "おはようございます😃\n昨日はスタンプのリアクションはありませんでした。\n素敵な1日をお過ごしください。"
  end

  def message_embed_hash
    {
      description: '**テスト投稿です！**',
      color: 0x2727ff,
      timestamp: Date.current.in_time_zone,
      footer: {
        icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png',
        text: 'posted'
      },
      thumbnail: {
        url: 'https://cdn.discordapp.com/embed/avatars/3.png'
      },
      image: {
        url: 'https://cdn.discordapp.com/attachments/23456/123456/55555.png'
      },
      author: {
        name: 'Hana',
        icon_url: 'https://cdn.discordapp.com/embed/avatars/3.png'
      },
      fields: [
        {
          name: ':tada: 獲得スタンプ: 20 :tada:',
          value: "2位〜5位は[Buzzcord](#{ENV['URL_HOST']})で確認できます。\nぜひ、チェックしてください👍"
        }
      ]
    }
  end

  def message_embed_hash_no_attachment
    {
      description: '**テスト投稿です！**',
      color: 0x2727ff,
      timestamp: Date.current.in_time_zone,
      footer: {
        icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png',
        text: 'posted'
      },
      thumbnail: {
        url: 'https://cdn.discordapp.com/embed/avatars/3.png'
      },
      image: {
        url: nil
      },
      author: {
        name: 'Hana',
        icon_url: 'https://cdn.discordapp.com/embed/avatars/3.png'
      },
      fields: [
        {
          name: ':tada: 獲得スタンプ: 20 :tada:',
          value: "2位〜5位は[Buzzcord](#{ENV['URL_HOST']})で確認できます。\nぜひ、チェックしてください👍"
        }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength
end
