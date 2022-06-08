# frozen_string_literal: true

module OmniauthMocks
  def discord_mock(name, uid)
    auth_hash = {
      provider: 'discord',
      uid: uid,
      info: {
        name: name
      },
      extra: {
        raw_info: {
          discriminator: '1234'
        }
      }
    }
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(auth_hash)
  end

  def mock_discord_failure!
    OmniAuth.config.mock_auth[:discord] = :invalid_credentials
  end
end
