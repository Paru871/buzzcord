# frozen_string_literal: true

class PostBuzzcord
  attr_reader :host, :rank

  #   TXT = <<'txt'
  #     {
  #     name: emojis[0][0],
  #     value: emojis[0][2],
  #     inline: true
  #     },
  #     {
  #     name: emojis[1][0],
  #     value: emojis[1][2],
  #     inline: true
  #     }
  # txt

  def initialize
    @host = ENV['URL_HOST']
    @rank = Rank.first
    @emoji_array = Emoji.where(rank_id: @rank.id).pluck(:emoji_name, :emoji_id, :count)
    @attachment_array = Attachment.where(rank_id: @rank.id).first
  end

  def post
    post_message(first_message(@rank))
    post_message(main_message(@rank, @attachment_array))
    post_message(second_message)
  end

  private

  def post_message(message)
    Discordrb::API::Channel.create_message(
      "Bot #{ENV['DISCORD_BOT_TOKEN']}",
      ENV['DISCORD_CHANNEL_ID'],
      message[:content],
      false,
      message[:embed]
      # nil,
      # nil,
      # nil,
      # 981561676904136845
    )
  end

  def first_message(rank)
    {
      content: "おはようございます😃\n昨日のこのdiscordサーバー内でのバズコードランキング第1位は…\n<@#{rank.author_id}>さんのこの発言でした！\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{rank.channel_id}/#{rank.message_id}",
      embed: nil
    }
  end

  def main_message(rank, attachments)
    {
      content: nil,
      embed: {
        description: rank.content,
        color: 599_498,
        timestamp: rank.posted_at,
        footer: {
          icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png',
          text: 'posted:'
        },
        author: { name: rank.author_name, icon_url: rank.author_avatar },
        image: {
          url: "https://cdn.discordapp.com/attachments/#{rank.channel_id}/#{attachments.attachment_id}/#{attachments.attachment_filename}"
        },
        thumbnail: { url: rank.author_avatar }
        # fields: [
        #   #   emojis.each { |emoji| "{name: #{emoji[0]}, value: #{emoji[2]}, inline: true},"}
        #   {
        #     name: emojis[0][0],
        #     value: emojis[0][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[1][0],
        #     value: emojis[1][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[2][0],
        #     value: emojis[2][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[3][0],
        #     value: emojis[3][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[4][0],
        #     value: emojis[4][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[5][0],
        #     value: emojis[5][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[6][0],
        #     value: emojis[6][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[7][0],
        #     value: emojis[7][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[8][0],
        #     value: emojis[8][2],
        #     inline: true
        #   },
        #   {
        #     name: emojis[9][0],
        #     value: emojis[9][2],
        #     inline: true
        #   }
        # ]
      }
    }
  end

  def second_message
    {
      content: '昨日の2位〜5位はサイトにてお知らせしていますのでぜひチェックしてね！',
      embed:
      {
        description: "昨日の全順位は[こちら](#{ENV['URL_HOST']})にアクセス！",
        color: 4_642_800
      }
    }
  end

  # def make_emoji_hash(emojis)
  #   multi_h = Hash.new { |hash,key| hash[key] = Hash.new {} }
  #   emojis.each do |emoji|
  #      array << "{name: #{emoji[0]}, value: #{emoji[2]}, inline: true}"
  #   end
  # end
end
