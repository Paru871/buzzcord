# frozen_string_literal: true

class RankOrderMaker
  def each_ranked_message
    messages_sorted_by_points.each.with_index(1) do |message, index|
      yield(message, index, make_channel_array(message), parsed_message_info(message))
    end
  end

  private

  def messages_sorted_by_points
    Reaction
      .where(reacted_at: Time.zone.yesterday.all_day)
      .order('sum_point desc').group(:channel_id, :message_id).sum(:point)
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

  def parsed_message_info(message)
    JSON.parse(Discordrb::API::Channel.message("Bot #{ENV['DISCORD_BOT_TOKEN']}", message[0][0], message[0][1]))
  end
end
