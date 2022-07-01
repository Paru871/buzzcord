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
      EmojisUpdater.new.create_emojis(message, rank_record)
      AttachmentsUpdater.new.create_attachments(message, rank_record)
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
    regexp = /(<:[0-9a-zA-Z]+:[0-9]+>)/
    regexp2 = /<(:[0-9a-zA-Z]+:)([0-9]+)>/
    contents_all = +''
    content.split(regexp).map do |word|
      matched = word.match(regexp2)
      if matched
        contents_all += "<img alt='#{matched[1]}' aria-label='#{matched[1]}' class='emoji' data-id='#{matched[2]}' data-type='emoji' draggable='false' src='https://cdn.discordapp.com/emojis/#{matched[2]}.webp?size=32&amp;quality=lossless'>"
      else
        contents_all += word
      end
    end
    contents_all
  end

  def avatar_url(message)
    uid = message['author']['id']
    avatar_id = message['author']['avatar']
    discriminator = message['author']['discriminator']
    avatar_id ? Discordrb::API::User.avatar_url(uid, avatar_id) : Discordrb::API::User.default_avatar(discriminator)
  end
end
