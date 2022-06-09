# frozen_string_literal: true

class RanksController < ApplicationController
  def index
    @ranks = Rank.includes(%i[emojis attachments])
    @guild_name = JSON.parse(Discordrb::API::Server.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_SERVER_ID']))['name']
  end
end
