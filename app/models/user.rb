# frozen_string_literal: true

class User < ApplicationRecord
  include ActionView::Helpers::AssetUrlHelper

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    avatar = auth_hash[:extra][:raw_info][:avatar]
    discriminator = auth_hash[:extra][:raw_info][:discriminator]

    # そのサーバーの所属メンバーかどうかを確認する
    Discordrb::API::Server.resolve_member("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_SERVER_ID'], uid)

    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = name
      user.avatar = if avatar
                      Discordrb::API::User.avatar_url(uid, avatar)
                    else
                      Discordrb::API::User.default_avatar(discriminator)
                    end
      user.discriminator = discriminator
    end
  end
end
