# frozen_string_literal: true

class PostFirst
  def self.message(
    _message,
    # username: 'ピヨルド',
    webhook_url: ENV['DISCORD_WEBHOOK_URL']
  )

    # if Rails.env.development?
    #   Discordrb::Webhooks::Embed.new(message, username: username, url: webhook_url)
    # else
    #   Rails.logger.info 'Message to Discord.'
    # end

    # bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN'], client_id: ENV['DISCORD_CLIENT_ID']

    # bot.message(with_text: 'bot embed') do |event|
    #   event.channel.send_embed do |embed|
    #     embed.title = 'fugafuga'
    #     embed.url = webhook_url
    #     embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: username)
    #   end
    # end

    # bot.run

    client = Discordrb::Webhooks::Client.new(url: webhook_url)
    client.execute do |builder|
      builder.add_embed do |embed|
        embed.title = 'fugafuga'
        embed.colour = 0x3c9b00
        embed.url = 'https://itunesconnect.apple.com'
        embed.description = 'New build uploaded to iTunes Connect with number '
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: 'iTunes Connect', url: 'https://itunesconnect.apple.com', icon_url: 'https://i.imgur.com/68CyCSp.png')
        embed.timestamp = Time.zone.now
      end
    end
  end

  def self.notify(
    title:,
    title_url:,
    description:,
    user:,
    webhook_url: ENV['DISCORD_WEBHOOK_URL']
  )
    user_url = Rails.application.routes.url_helpers.user_url(
      user,
      host: 'bootcamp.fjord.jp',
      protocol: 'https'
    )

    author = { name: user.login_name, url: user_url, icon_url: user.avatar_url }

    embed = Discord::Embed.new do
      title title
      url title_url
      description description
      author author
      color '4638a0'
    end

    if Rails.env.development?
      Discord::Notifier.message(embed, url: webhook_url)
    else
      Rails.logger.info 'Notify to Discord.'
    end
  end
end
