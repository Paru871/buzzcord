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
        description: set_content_post,
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
  end
  # rubocop:enable Metrics/MethodLength

  private

  def make_header_reaction_zero
    "おはようございます😃\n昨日はスタンプのリアクションはありませんでした。\n素敵な1日をお過ごしください。"
  end

  def make_header_thread
    "おはようございます😃\n昨日バズった発言の第1位は…\n「#{@rank.channel_name}チャンネル、#{@rank.thread_name}スレッド」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{@rank.thread_id}/#{@rank.message_id}"
  end

  def make_header_channel
    "おはようございます😃\n昨日バズった発言の第1位は…\n「#{@rank.channel_name}チャンネル」での<@#{@rank.author_id}>さんのこちらの発言でした:tada:\nhttps://discord.com/channels/#{ENV['DISCORD_SERVER_ID']}/#{@rank.channel_id}/#{@rank.message_id}"
  end

  def set_content_post
    "**#{@rank.content_post}**"
  end

  def set_icon_url
    'https://cdn.discordapp.com/embed/avatars/0.png'
  end

  def set_icon_text
    'posted'
  end

  def set_image
    return if @attachment.blank?

    "https://cdn.discordapp.com/attachments/#{@rank.thread_id || @rank.channel_id}/#{@attachment.attachment_id}/#{@attachment.attachment_filename}"
  end

  def set_fields_name
    ":tada: 獲得スタンプ: #{@rank.total_emojis_count} :tada:"
  end

  def set_fields_value
    "2位〜5位は[Buzzcord](#{ENV['URL_HOST']})で確認できます。\nぜひ、チェックしてください👍"
  end
end
