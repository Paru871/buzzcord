# frozen_string_literal: true

class PostBuzzcord
  class << self
    def post(formatter)
      Discordrb::API::Channel.create_message("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_CHANNEL_ID'], formatter.header, false, formatter.embed_message)
    end
  end
end

  # def initialize
  #   @host = ENV['URL_HOST']
  #   @rank = Rank.first
  #   @emoji_array = Emoji.where(rank_id: @rank.id).pluck(:emoji_name, :emoji_id, :count) if @rank.present?
  #   @attachment = Attachment.where(rank_id: @rank.id).first if @rank.present?
  # end

  # def post
  #   if @rank.blank?
  #     post_message(reaction_zero)
  #     return
  #   end

  #   if @rank.thread_id.present?
  #     post_message(first_message_thread(@rank))
  #   else
  #     post_message(first_message_channel(@rank))
  #   end

  #   main_message(@rank, @attachment)
  #   post_message(second_message)
  # end

  # private

  # def post_message(message)
  #   Discordrb::API::Channel.create_message("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_CHANNEL_ID'], message[:content], false, message[:embed])
  # end

  # def first_message_thread(rank)
  #   {
  #     # rubocop:disable Layout/LineLength
  #     content: "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{rank.channel_name}チャンネル、#{rank.thread_name}スレッド」での<@#{rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{rank.thread_id}/#{rank.message_id}",
  #     embed: nil
  #     # rubocop:enable Layout/LineLength
  #   }
  # end

  # def reaction_zero
  #   {
  #     content: "おはようございます😃Buzzcordお知らせbotです。\n昨日このDiscordサーバー内では、絵文字スタンプの反応がありませんでした。\n素敵な1日をお過ごしください👍",
  #     embed: nil
  #   }
  # end

  # # rubocop:disable Layout/LineLength, Metrics/MethodLength
  # def first_message_thread(rank)
  #   {
  #     content: "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{rank.channel_name}チャンネル、#{rank.thread_name}スレッド」での<@#{rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{rank.thread_id}/#{rank.message_id}",
  #     embed: nil
  #   }
  # end

  # def main_message(rank, attachment)
  #   message = nil
  #   channel = rank.thread_id || rank.channel_id
  #   file = File.read('./embed.json')
  #   embed_json = JSON.parse(file)['embed']
  #   embed_json['title'] = rank.content_post
  #   embed_json['color'] = 0x2727ff
  #   embed_json['author']['name'] = rank.author_name
  #   embed_json['author']['icon_url'] = rank.author_avatar
  #   embed_json['footer']['text'] = 'posted:'
  #   embed_json['footer']['icon_url'] = 'https://cdn.discordapp.com/embed/avatars/0.png'
  #   embed_json['timestamp'] = rank.posted_at
  #   embed_json['thumbnail']['url'] = rank.author_avatar
  #   embed_json['fields'][0]['name'] = ':tada: 獲得絵文字スタンプ数:tada: '
  #   embed_json['fields'][0]['value'] = rank.total_emojis_count.to_s
  #   if attachment.present?
  #     embed_json['image']['url'] = "https://cdn.discordapp.com/attachments/#{channel}/#{attachment.attachment_id}/#{attachment.attachment_filename}"
  #   end
  #   Discordrb::API::Channel.create_message("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_CHANNEL_ID'], message, false, embed_json)
  # end

  # def first_message_channel(rank)
  #   {
  #     content: "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{rank.channel_name}チャンネル」での<@#{rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{rank.channel_id}/#{rank.message_id}",
  #     embed: nil
  #   }
  # end


  # def main_message(rank, attachment)
  #   embed_hash = {
  #     title: rank.content_post,
  #     color: 0x2727ff,
  #     author: {
  #       name: rank.author_name,
  #       icon_url: rank.author_avatar
  #     },
  #     footer: {
  #       text: 'posted:',
  #       icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png'
  #     },
  #     timestamp: rank.posted_at,
  #     thumbnail: {
  #       url: rank.author_avatar
  #     },
  #     fields: [
  #       {
  #         name: ':tada: 獲得絵文字スタンプ数:tada: ',
  #         value: rank.total_emojis_count.to_s
  #       }
  #     ]
  #   }
  #   if attachment.present?
  #     embed_hash[:image] = { "url": "https://cdn.discordapp.com/attachments/#{rank.thread_id || rank.channel_id}/#{attachment.attachment_id}/#{attachment.attachment_filename}" }
  #   end
  #   Discordrb::API::Channel.create_message("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_CHANNEL_ID'], nil, false, embed_hash)
  # end
  # # rubocop:enable Layout/LineLength, Metrics/MethodLength

  # def second_message
  #   {
  #     content: nil,
  #     embed:
  #     {
  #       description: "昨日のBuzzcord2位〜5位はサイトにてお知らせしていますのでぜひチェックしてね👍\n昨日のランキングは[こちら](#{ENV['URL_HOST']})にアクセス！",
  #       color: 0x7fffff
  #     }
  #   }
  # end
# end
