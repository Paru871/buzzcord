# frozen_string_literal: true

class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
  end

  def start
    recordings
    member_watching
    @bot.run
  end

  private

  def recordings
    @bot.reaction_add do |event|
      if event.server.id.to_s == ENV['DISCORD_SERVER_ID']
        point = 1
        reaction_create(event, point)
      end
    end

    @bot.reaction_remove do |event|
      if event.server.id.to_s == ENV['DISCORD_SERVER_ID']
        point = -1
        reaction_create(event, point)
      end
    end
  end

  def member_watching
    @bot.member_leave do |event|
      user_id = event.user.id
      user = User.find_by(uid: user_id)
      user&.destroy
    end

    @bot.member_update do |event|
      uid = event.user.id
      updated_member = JSON.parse(Discordrb::API::User.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", uid))

      name = updated_member['username']
      discriminator = updated_member['discriminator']
      avatar = avatar_url(uid, updated_member['avatar'], discriminator)

      user = User.find_by(uid: uid)
      if user
        user.update!(name: name) if user.name != name
        user.update!(avatar: avatar) if user.avatar != avatar
        user.update!(discriminator: discriminator) if user.discriminator != discriminator
      end
    end
  end

  def reaction_create(event, point)
    Reaction.create! do |reaction|
      reaction.channel_id = event.message.channel.id
      reaction.message_id = event.message.id
      reaction.user_id = event.user.id
      reaction.emoji_name = event.emoji.name
      reaction.emoji_id = event.emoji.id
      reaction.reacted_at = Time.current
      reaction.point = point
    end
  end

  def avatar_url(uid, avatar_id, discriminator)
    if avatar_id
      Discordrb::API::User.avatar_url(uid, avatar_id)
    else
      Discordrb::API::User.default_avatar(discriminator)
    end
  end
end
