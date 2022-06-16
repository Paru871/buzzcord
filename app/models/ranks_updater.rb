# frozen_string_literal: true

class RanksUpdater
  def update_all
    # 現在のランキング情報をリセット
    Rank.delete_all

    # 発言ごとに昨日ついた絵文字合計で降順に並べ替え、そこからランキング情報を再作成する
    create_ranks
  end

  private

  def create_ranks
    RankOrderMaker.new.each_ranked_message do |message, index|
      rank_record = create_record(message, index)
      # emojis_update(message, rank_record)
      # attachments_update(message, rank_record)
      EmojisUpdater.new.create_emojis(message, rank_record)
      AttachmentsUpdater.new.create_attachments(message_info, rank_record)
    end
  end

  def create_record(message, index)
    channel_array = make_channel_array(message)
    message_all_info = message_info(message)
    Rank.create do |rank|
      rank.order = index
      rank.thread_id = channel_array[0]
      rank.thread_name = channel_array[1]
      rank.channel_id = channel_array[2]
      rank.channel_name = channel_array[3]
      rank.message_id = message[0][1]
      rank.content = convert_custom_emoji(message_all_info['content'])
      rank.content_post = message_all_info['content']
      rank.author_id = message_all_info['author']['id']
      rank.author_name = message_all_info['author']['username']
      rank.author_avatar = avatar_url(message_all_info)
      rank.author_discriminator = message_all_info['author']['discriminator']
      rank.posted_at = message_all_info['timestamp']
      rank.total_emojis_count = message[1]
    end
  end

  def make_channel_array(message)
    channel = message[0][0]
    parsed = JSON.parse(Discordrb::API::Channel.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", channel))
    if parsed.key?('thread_metadata')
      [channel, parsed['name'], parsed['parent_id'],
       (JSON.parse(Discordrb::API::Channel.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", parsed['parent_id'])))['name']]
    else
      [nil, nil, channel, parsed['name']]
    end
  end

  def message_info(message)
    JSON.parse(Discordrb::API::Channel.message("Bot #{ENV['DISCORD_BOT_TOKEN']}", message[0][0], message[0][1]))
  end

  def convert_custom_emoji(content)
    regexp = /(<:[a-z]+:[0-9]+>)/
    regexp2 = /<(:[a-z]+:)([0-9]+)>/
    content.split(regexp).map do |word|
      matched = word.match(regexp2)
      matched ? [matched[1], matched[2]] : word
    end
  end

  def avatar_url(message)
    uid = message['author']['id']
    avatar_id = message['author']['avatar']
    discriminator = message['author']['discriminator']
    avatar_id ? Discordrb::API::User.avatar_url(uid, avatar_id) : Discordrb::API::User.default_avatar(discriminator)
  end

  def emojis_update(message, rank_record)
    return if message[1].zero?

    emoji_hash = yesterday_emojis(message)
    emoji_hash.each do |hash_emoji|
      rank_record.emojis.create do |emoji|
        emoji.emoji_id = hash_emoji[0][1]
        emoji.emoji_name = hash_emoji[0][0]
        emoji.count = hash_emoji[1]
      end
    end
  end

  def yesterday_emojis(message)
    Reaction
      .where(reacted_at: Time.zone.yesterday.all_day, message_id: message[0][1])
      .order('sum_point desc').group('emoji_name', 'emoji_id').sum(:point)
  end

  def attachments_update(message, rank_record)
    message_info = JSON.parse(Discordrb::API::Channel.message("Bot #{ENV['DISCORD_BOT_TOKEN']}", message[0][0], message[0][1]))
    return if message_info.blank?

    message_info['attachments'].each do |hash_attachment|
      rank_record.attachments.create do |attachment|
        attachment.attachment_id = hash_attachment['id']
        attachment.attachment_filename = hash_attachment['filename']
      end
    end
  end
end
