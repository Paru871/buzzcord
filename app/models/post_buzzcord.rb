# frozen_string_literal: true

class PostBuzzcord
  def initialize
    @host = ENV['URL_HOST']
    @rank = Rank.first
    @emoji_array = Emoji.where(rank_id: @rank.id).pluck(:emoji_name, :emoji_id, :count)
    @attachment = Attachment.where(rank_id: @rank.id).first
  end

  def post
    if @rank.thread_id.present?
      post_message(first_message_thread(@rank))
    else
      post_message(first_message_channel(@rank))
    end
    main_message(@rank, @attachment)
    post_message(second_message)
  end

  private

  def post_message(message)
    Discordrb::API::Channel.create_message("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_CHANNEL_ID'], message[:content], false, message[:embed])
  end

  def first_message_thread(rank)
    {
      content: "おはようございます😃\n昨日のこのdiscordサーバー内でのバズコードランキング第1位は…\n「#{rank.channel_name}チャンネル、#{rank.thread_name}スレッド」での<@#{rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{rank.thread_id}/#{rank.message_id}",
      embed: nil
    }
  end

  def first_message_channel(rank)
    {
      content: "おはようございます😃\n昨日のこのdiscordサーバー内でのバズコードランキング第1位は…\n「#{rank.channel_name}チャンネル」での<@#{rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{rank.channel_id}/#{rank.message_id}",
      embed: nil
    }
  end

  def main_message(rank, attachment)
    message = nil
    channel = rank.thread_id.presence || rank.channel.id
    file = File.read('./embed.json')
    embed_json = JSON.parse(file)['embed']
    embed_json['title'] = rank.content
    embed_json['color'] = 599_498
    embed_json['author']['name'] = rank.author_name
    embed_json['author']['icon_url'] = rank.author_avatar
    embed_json['footer']['text'] = 'posted:'
    embed_json['footer']['icon_url'] = 'https://cdn.discordapp.com/embed/avatars/0.png'
    embed_json['timestamp'] = rank.posted_at
    embed_json['thumbnail']['url'] = rank.author_avatar
    embed_json['fields'][0]['name'] = ':tada: 獲得絵文字スタンプ数:tada: '
    embed_json['fields'][0]['value'] = rank.total_emojis_count.to_s
    if attachment.present?
      embed_json['image']['url'] = "https://cdn.discordapp.com/attachments/#{channel}/#{attachment.attachment_id}/#{attachment.attachment_filename}"
    end
    Discordrb::API::Channel.create_message("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_CHANNEL_ID'], message, false, embed_json)
  end

  def second_message
    {
      content: '昨日のバズコード2位〜5位はサイトにてお知らせしていますのでぜひチェックしてね！',
      embed:
      {
        description: "昨日の全順位は[こちら](#{ENV['URL_HOST']})にアクセス！",
        color: 4_642_800
      }
    }
  end
end
