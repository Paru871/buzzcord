# frozen_string_literal: true

class PostBuzzcord
  class << self
    def post(formatter)
      Discordrb::API::Channel.create_message("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_CHANNEL_ID'], formatter.header, false, formatter.embed_message)
    end
