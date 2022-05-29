# frozen_string_literal: true

class RanksUpdater
  def update_all
    # 現在のランキング情報をリセット
    Rank.delete_all

    # ランキング情報を再作成する
    create_ranks
  end

  private

  def create_ranks
    # yesterday_reactions = Reaction.where(reacted_at: Time.zone.yesterday.all_day)
    yesterday_reactions = Reaction.all
    # sorted_yesterday_massages = yesterday_reactions.limit(30).order('sum_point desc').group(:message_id).sum(:point)
    sorted_yesterday_massages = yesterday_reactions.order('sum_point desc').group(:message_id).sum(:point)

    sorted_yesterday_massages.each.with_index(1) do |message, index|
      channel = yesterday_reactions.find_by(message_id: message[0]).channel_id
      channel_hash = make_channel_hash(channel)
      message_information = Discordrb::API::Channel.message(ENV['DISCORD_BOT_TOKEN_BOT'], channel, message[0])
      message_information_parsed = JSON.parse(message_information)

      rank_record = rank_data_creation(index, channel_hash, message, message_information_parsed)

      create_emojis(message_information_parsed['reactions'], yesterday_reactions, message, rank_record)

      create_attachments(message_information_parsed, rank_record)
    end
  end

  def make_channel_hash(channel)
    response = Discordrb::API::Channel.resolve(ENV['DISCORD_BOT_TOKEN_BOT'], channel)
    parsed = JSON.parse(response)
    h = Hash.new([])
    if parsed.key?('thread_metadata')
      h[:thread_id] = channel
      h[:thread_name] = parsed['name']
      h[:channel_id] = parsed['parent_id']
      response = Discordrb::API::Channel.resolve(ENV['DISCORD_BOT_TOKEN_BOT'], parsed['parent_id'])
      h[:channel_name] = (JSON.parse(response))['name']
    else
      h[:channel_id] = channel
      h[:channel_name] = parsed['name']
      h[:thread_id] = nil
      h[:thread_name] = nil
    end
    h
  end

  def rank_data_creation(index, channel_hash, message, message_information_parsed)
    Rank.create do |rank|
      rank.order = index
      rank.channel_id = channel_hash[:channel_id]
      rank.channel_name = channel_hash[:channel_name]
      rank.thread_id = channel_hash[:thread_id]
      rank.thread_name = channel_hash[:thread_name]
      rank.message_id = message[0]
      rank.content = message_information_parsed['content']
      rank.author_id = message_information_parsed['author']['id']
      rank.author_name = message_information_parsed['author']['username']
      rank.author_avatar = message_information_parsed['author']['avatar']
      rank.author_discriminator = message_information_parsed['author']['discriminator']
    end
  end

  def create_emojis(emoji_hash, yesterday_reactions, message, rank_record)
    emoji_hash.each do |hash_emoji|
      next unless yesterday_reactions.where(message_id: message[0], emoji_name: hash_emoji['emoji']['name']).sum(:point).positive?

      rank_record.emojis.create do |emoji|
        emoji.emoji_id = hash_emoji['emoji']['id']
        emoji.emoji_name = hash_emoji['emoji']['name']
        emoji.count = yesterday_reactions.where(message_id: message[0], emoji_name: hash_emoji['emoji']['name']).sum(:point)
      end
    end
  end

  def create_attachments(message_information_parsed, rank_record)
    message_information_parsed['attachments'].each do |hash_attachment|
      rank_record.attachments.create do |attachment|
        attachment.attachment_id = hash_attachment['id']
        attachment.attachment_filename = hash_attachment['filename']
      end
    end
  end
end
