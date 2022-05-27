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
    # today_reactions = Reaction.where(reacted_at: Time.zone.yesterday.all_day)
    today_reactions = Reaction.all
    # sorted_today_massages = today_reactions.limit(30).order('sum_point desc').group(:message_id).sum(:point)
    sorted_today_massages = today_reactions.order('sum_point desc').group(:message_id).sum(:point)

    # index = 1
    sorted_today_massages.each.with_index(1) do |message, index|
      # unless message[1] == points
      #   index += 1
      #   points = message[1]
      # end
      channel = today_reactions.find_by(message_id: message[0]).channel_id
      response = Discordrb::API::Channel.resolve(ENV['DISCORD_BOT_TOKEN_BOT'], channel)
      parsed = JSON.parse(response)

      if parsed.key?('thread_metadata')
        thread_id = channel
        thread_name = parsed['name']
        channel_id = parsed['parent_id']
        response = Discordrb::API::Channel.resolve(ENV['DISCORD_BOT_TOKEN_BOT'], channel_id)
        channel_name = (JSON.parse(response))['name']
      else
        channel_id = channel
        channel_name = parsed['name']
      end

      message_information = Discordrb::API::Channel.message(ENV['DISCORD_BOT_TOKEN_BOT'], channel_id, message[0])
      message_information_parsed = JSON.parse(message_information)

      rank_record = Rank.create do |rank|
        rank.order = index
        rank.channel_id = channel_id
        rank.channel_name = channel_name
        rank.thread_id = thread_id
        rank.thread_name = thread_name
        rank.message_id = message[0]
        rank.content = message_information_parsed['content']
        rank.author_id = message_information_parsed['author']['id']
        rank.author_name = message_information_parsed['author']['username']
        rank.author_avatar = message_information_parsed['author']['avatar']
        rank.author_discriminator = message_information_parsed['author']['discriminator']
      end

      create_emojis(message_information_parsed['reactions'], today_reactions, message, rank_record)
      # message_information_parsed['reactions'].each do |hash_emoji|
      #   next unless today_reactions.where(message_id: message[0], emoji_name:hash_emoji['emoji']['name']).sum(:point) > 0
      #   rank_record.emojis.create do |emoji|
      #     emoji.emoji_id = hash_emoji['emoji']['id']
      #     emoji.emoji_name = hash_emoji['emoji']['name']
      #     emoji.count = today_reactions.where(message_id: message[0], emoji_name:hash_emoji['emoji']['name']).sum(:point)
      #   end
      # end

      create_attachments(message_information_parsed, rank_record)
      # message_information_parsed['attachments'].each do |hash_attachment|
      #   rank_record.attachments.create do |attachment|
      #     attachment.attachment_id = hash_attachment['id']
      #     attachment.attachment_filename = hash_attachment['filename']
      #   end
      # end
    end
  end

  def create_emojis(emoji_hash, today_reactions, message, rank_record)
    emoji_hash.each do |hash_emoji|
      next unless today_reactions.where(message_id: message[0], emoji_name: hash_emoji['emoji']['name']).sum(:point).positive?

      rank_record.emojis.create do |emoji|
        emoji.emoji_id = hash_emoji['emoji']['id']
        emoji.emoji_name = hash_emoji['emoji']['name']
        emoji.count = today_reactions.where(message_id: message[0], emoji_name: hash_emoji['emoji']['name']).sum(:point)
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