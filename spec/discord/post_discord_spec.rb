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

        # @stub_second = stub_request(:post, @message_url).with(body: hash_including(second_message_hash))

        # stub_request(:post, @message_url).with(body: hash_including(first_message_thread_hash(@rank)))
        # stub_request(:post, @message_url).with(body: hash_including(main_message_hash(@rank, @attachment)))
        # stub_request(:post, @message_url).with(body: hash_including(second_message_hash))
        @stub_first_thread = stub_request(:post, @message_url).with(body: hash_including(first_message_thread_hash(@rank)))
        @stub_main = stub_request(:post, @message_url).with(body: hash_including(main_message_hash(@rank, @attachment)))
        @stub_second = stub_request(:post, @message_url).with(body: hash_including(second_message_hash))
      end
      it 'スレッド名を含んだ3つの発言が正常に送信される' do
        PostBuzzcord.new.post
        @stub_first_thread = stub_request(:post, @message_url).with(body: first_message_thread_hash(@rank))
        @stub_main = stub_request(:post, @message_url).with(body: main_message_hash(@rank, @attachment))
        @stub_second = stub_request(:post, @message_url).with(body: second_message_hash)
        # expect(WebMock).to have_requested(@stub_first_thread)
        # expect(@stub_first_thread).to have_been_requested
        # expect(@stub_main).to have_been_requested
        # expect(@stub_second).to have_been_requested

        # expect(a_request(:post, @message_url)).to have_been_made.times(3)
        # webmock1 = stub_request(:post, @message_url).
        # to_return(body: first_message_thread_hash(@rank), status: 200)
        # webmock2 = stub_request(:post, @message_url).to_return(body: main_message_hash(@rank, @attachment), status: 200)
        # webmock3 = stub_request(:post, @message_url).to_return(body: second_message_hash, status: 200)
        # expect(webmock1).to have_been_requested
        # expect(webmock2).to have_been_requested
        # expect(webmock3).to have_been_requested
        expect(@stub_first_thread).to have_requested(:post, @message_url)
        expect(@stub_main).to have_requested(:post, @message_url)
        expect(@stub_second).to have_requested(:post, @message_url)
        # expect(WebMock).to have_requested(:post, @message_url).
        # with(body: hash_including(first_message_thread_hash(@rank)))
        # expect(WebMock).to have_requested(:post, @message_url).
        # with(body: hash_including(main_message_hash(@rank, @attachment)))
        # expect(WebMock).to have_requested(:post, @message_url).
        # with(body: hash_including(second_message_hash))

        # expect(@stub_first_thread).to have_requested(:post, @message_url).with(body: hash_including(first_message_thread_hash(@rank)))
        # expect(@stub_main).to have_requested(:post, @message_url).with(body: hash_including(main_message_hash(@rank, @attachment)))
        # expect(@stub_second).to have_requested(:post, @message_url).with(body: hash_including(second_message_hash))

        # expect(a_request(:post, @message_url).with(body: hash_including(first_message_thread_hash(@rank),
        # headers: {'Content-Type' => 'application/json'}))).to have_been_made
        # expect(a_request(:post, @message_url).with(body: hash_including(main_message_hash(@rank, @attachment),
        # headers: {'Content-Type' => 'application/json'}))).to have_been_made
        # expect(a_request(:post, @message_url).with(body: hash_including(second_message_hash),
        # headers: {'Content-Type' => 'application/json'})).to have_been_made
      end
    end

    context 'ランキング1位の発言がチャンネル内だったとき' do
      it 'チャンネル名のみを表示する一連の発言が正常に送信される' do
      end
    end

    context 'リアクションがなかったとき' do
      before do
        @stub_reaction_zero = stub_request(:post, @message_url).with(body: hash_including(reaction_zero_hash))
        @rank = nil
      end
      it 'リアクション0のお知らせ投稿が正常に送信される' do
        PostBuzzcord.new.post
        expect(@rankreaction_zero).to have_requested(:post, @message_url)
      end
    end

    # rubocop:disable Layout/LineLength, Metrics/MethodLength
    def first_message_thread_hash(rank)
      {
        content: "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{rank.channel_name}チャンネル、#{rank.thread_name}スレッド」での<@#{rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{rank.thread_id}/#{rank.message_id}",
        embed: nil
      }
    end

    def main_message_hash(rank, attachment)
      {
        content: nil,
        tts: false,
        embed: {
          title: rank.content_post,
          color: 0x2727ff,
          author: {
            name: rank.author_name,
            icon_url: rank.author_avatar
          },
          footer: {
            text: 'posted:',
            icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png'
          },
          timestamp: rank.posted_at,
          thumbnail: {
            url: rank.author_avatar
          },
          fields: [
            {
              name: ':tada: 獲得絵文字スタンプ数:tada: ',
              value: rank.total_emojis_count.to_s
            }
          ],
          image: {
            url: "https://cdn.discordapp.com/attachments/#{rank.thread_id || rank.channel_id}/#{attachment.attachment_id}/#{attachment.attachment_filename}"
          }
        }
      }
    end

    def second_message_hash
      {
        content: nil,
        embed:
        {
          description: "昨日のBuzzcord2位〜5位はサイトにてお知らせしていますのでぜひチェックしてね👍\n昨日のランキングは[こちら](#{ENV['URL_HOST']})にアクセス！",
          color: 0x7fffff
        }
      }
    end

    def reaction_zero_hash
      {
        content: "おはようございます😃Buzzcordお知らせbotです。\n昨日このDiscordサーバー内では、絵文字スタンプの反応がありませんでした。\n素敵な1日をお過ごしください👍",
        embed: nil
      }
    end
    # rubocop:enable Layout/LineLength, Metrics/MethodLength
  end
end
