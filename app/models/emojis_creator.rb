# frozen_string_literal: true

class EmojisCreator
  def create_emojis(message, rank_record)
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

  private

  def yesterday_emojis(message)
    Reaction
      .where(reacted_at: Time.zone.yesterday.all_day, message_id: message[0][1])
      .order('sum_point desc').group('emoji_name', 'emoji_id').sum(:point)
  end
end
