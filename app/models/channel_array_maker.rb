# frozen_string_literal: true

class ChannelArrayMaker
  def self.call(message)
    channel = message[0][0]
    parsed = fetch_channel(channel)
    if parsed.key?('thread_metadata')
      [channel, parsed['name'], parsed['parent_id'],
       fetch_channel(parsed['parent_id'])['name']]
    else
      [nil, nil, channel, parsed['name']]
    end
  end

  def self.fetch_channel(channel_id, attempt: 0)
    JSON.parse(DiscordApiClient.new.fetch_channel_info(channel_id))
  rescue JSON::ParserError
    raise if attempt >= 3

    sleep(2**attempt)
    fetch_channel(channel_id, attempt: attempt + 1)
  end
  private_class_method :fetch_channel
end
