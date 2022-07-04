# frozen_string_literal: true

class PostBuzzcord
  def self.post(formatter)
    DiscordApiClient.new.create_post(formatter.header, formatter.embed_message)
  end
end
