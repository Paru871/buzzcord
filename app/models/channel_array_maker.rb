# frozen_string_literal: true

class ChannelArrayMaker
  def self.call(message)
    channel = message[0][0]
    parsed = JSON.parse(DiscordApiClient.new.fetch_channel_info(channel))
    if parsed.key?('thread_metadata')
      [channel, parsed['name'], parsed['parent_id'],
       (JSON.parse(DiscordApiClient.new.fetch_channel_info(parsed['parent_id'])))['name']]
    else
      [nil, nil, channel, parsed['name']]
    end
  end
end
