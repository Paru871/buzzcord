# frozen_string_literal: true

class DiscordApiClient
  def initialize
    @token = ENV['DISCORD_BOT_TOKEN']
    @channel_id = ENV['DISCORD_CHANNEL_ID']
    @server_id = ENV['DISCORD_SERVER_ID']
  end

  def bot_start(message)
    Discordrb::API::Channel.message("Bot #{@token}", message[0][0], message[0][1])
  end

  def fetch_user_info(uid)
    Discordrb::API::User.resolve("Bot #{@token}", uid)
  end

  def make_avatar_url(uid, avatar_id)
    Discordrb::API::User.avatar_url(uid, avatar_id)
  end

  def make_default_avatar(discriminator)
    Discordrb::API::User.default_avatar(discriminator)
  end

  def create_post(header, embed_message)
    Discordrb::API::Channel.create_message("Bot #{@token}", @channel_id, header, false, embed_message)
  end

  def fetch_channel_info(channel)
    Discordrb::API::Channel.resolve("Bot #{@token}", channel)
  end

  def fetch_server_member_info(uid)
    Discordrb::API::Server.resolve_member("Bot #{@token}", @server_id, uid)
  end
end
