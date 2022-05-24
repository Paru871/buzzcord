# frozen_string_literal: true

class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
  end

  def start
    recordings
    @bot.run
  end

  def recordings
    @bot.reaction_add do |event|
      if event.server.id.to_s == ENV['DISCORD_SERVER_ID']
        type = 'add'
        reaction_create(event, type)
      end
    end

    @bot.reaction_remove do |event|
      if event.server.id.to_s == ENV['DISCORD_SERVER_ID']
        type = 'remove'
        reaction_create(event, type)
      end
    end
  end

  private

  def reaction_create(event, type)
    Reaction.create do |reaction|
      reaction.channel_id = event.message.channel.id
      reaction.message_id = event.message.id
      reaction.user_id = event.user.id
      reaction.emoji_name = event.emoji.name
      reaction.emoji_id = event.emoji.id
      reaction.reacted_at = Time.current
      reaction.type = type
    end
  end
end
