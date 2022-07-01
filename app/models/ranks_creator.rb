# frozen_string_literal: true

class RanksCreator
  class << self
    def call(message, index)
      channel_array = ChannelArrayMaker.call(message)
      message_all_info = message_info(message)
      Rank.create do |rank|
        rank.order = index
        rank.thread_id = channel_array[0]
        rank.thread_name = channel_array[1]
        rank.channel_id = channel_array[2]
        rank.channel_name = channel_array[3]
        rank.message_id = message[0][1]
        rank.content = CustomEmojiConverter.call(message_all_info['content'])
        rank.content_post = message_all_info['content']
        rank.author_id = message_all_info['author']['id']
        rank.author_name = message_all_info['author']['username']
        rank.author_avatar = avatar_url(message_all_info)
        rank.author_discriminator = message_all_info['author']['discriminator']
        rank.posted_at = message_all_info['timestamp']
        rank.total_emojis_count = message[1]
      end
    end

    private

    def message_info(message)
      JSON.parse(DiscordApiClient.new.fetch_message_info(message))
    end

    def avatar_url(message)
      uid = message['author']['id']
      avatar_id = message['author']['avatar']
      discriminator = message['author']['discriminator']
      avatar_id ? DiscordApiClient.new.make_avatar_url(uid, avatar_id) : DiscordApiClient.new.make_default_avatar(discriminator)
    end
  end
end
