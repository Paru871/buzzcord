# frozen_string_literal: true

class BotMessageFormatter
  def initialize
    @host = ENV['URL_HOST']
    @rank = Rank.first
    @emoji_array = Emoji.where(rank_id: @rank.id).pluck(:emoji_name, :emoji_id, :count) if @rank.present?
    @attachment = Attachment.where(rank_id: @rank.id).first if @rank.present?
  end

  def header
    if @rank.blank?
      make_header_reaction_zero
    elsif @rank.thread_id.present?
      make_header_thread
    else
      make_header_channel
    end
  end

  # rubocop:disable Metrics/MethodLength
  def embed_message
    if @rank.blank?
      nil
    else
      {
        title: @rank.content_post,
        description: set_description,
        url: set_url,
        color: 0x2727ff,
        timestamp: @rank.posted_at,
        footer: {
          icon_url: set_icon_url,
          text: set_icon_text
        },
        thumbnail: {
          url: @rank.author_avatar
        },
        image: {
          url: set_image
        },
        author: {
          name: @rank.author_name,
          icon_url: @rank.author_avatar
        },
        fields: [
          {
            name: set_fields_name,
            value: set_fields_value
          }
        ]
      }
    end
    # rubocop:enable Metrics/MethodLength
  end

  private

  def make_header_reaction_zero
    "おはようございます😃Buzzcordお知らせbotです。\n昨日このDiscordサーバー内では、絵文字スタンプの反応がありませんでした。\n素敵な1日をお過ごしください👍"
  end

  def make_header_thread
    "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{@rank.channel_name}チャンネル、#{@rank.thread_name}スレッド」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:"
  end

  def make_header_channel
    "おはようございます😃\n昨日のこのDiscordサーバー内でのBuzzcordランキング第1位は…\n「#{@rank.channel_name}チャンネル」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{@rank.channel_id}/#{@rank.message_id}"
  end

  def set_description
    ''
  end

  def set_url
    "https://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{@rank.channel_id}/#{@rank.message_id}"
  end

  def set_icon_url
    'https://cdn.discordapp.com/embed/avatars/0.png'
  end

  def set_icon_text
    'posted:'
  end

  def set_image
    if @attachment.present?
      "https://cdn.discordapp.com/attachments/#{@rank.thread_id || @rank.channel_id}/#{@attachment.attachment_id}/#{@attachment.attachment_filename}"
    else
      ''
    end
  end

  def set_fields_name
    ":tada: 獲得絵文字スタンプ数: #{@rank.total_emojis_count} :tada:"
  end

  def set_fields_value
    "昨日のBuzzcord2位〜5位はサイトにてお知らせしていますのでぜひチェックしてね👍\n昨日のランキングは[こちら](#{ENV['URL_HOST']})にアクセス！"
  end
end
