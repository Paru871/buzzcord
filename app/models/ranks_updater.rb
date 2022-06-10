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
    RankOrderMaker.new.each_ranked_message do |message, index, channel_array, message_info|
      rank_record = Rank.create do |rank|
        rank.order = index
        rank.thread_id = channel_array[0]
        rank.thread_name = channel_array[1]
        rank.channel_id = channel_array[2]
        rank.channel_name = channel_array[3]
        rank.message_id = message[0][1]
        rank.content = convert_custom_emoji(message_info['content'])
        rank.content_post = message_info['content']
        rank.author_id = message_info['author']['id']
        rank.author_name = message_info['author']['username']
        rank.author_avatar = avatar_url(message_info)
        rank.author_discriminator = message_info['author']['discriminator']
        rank.posted_at = message_info['timestamp']
        rank.total_emojis_count = message[1]
      end
      EmojisUpdater.new.create_emojis(message, rank_record)
      AttachmentsUpdater.new.create_attachments(message_info, rank_record)
    end
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
end
