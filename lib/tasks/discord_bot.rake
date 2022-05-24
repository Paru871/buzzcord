# frozen_string_literal: true

namespace :discord_bot do
  desc 'start discord bot'
  task start: :environment do
    DiscordBot.new.start
  end
end
