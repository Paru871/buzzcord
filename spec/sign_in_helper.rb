# frozen_string_literal: true

module SignInHelper
  def login_user(user)
    visit homes_path
    OmniAuth.config.mock_auth[:discord] = nil
    Rails.application.env_config['omniauth.auth'] = discord_mock(user.name, user.uid)
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}").to_return(body: { "owner_id": '123456' }.to_json, status: 200)
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{user.uid}")
    ensure_browser_size if Capybara.current_driver == :selenium_chrome_headless
    click_on 'Discordでログイン'
    @current_user = user
    # OmniAuth.config.add_mock(
    #   user.provider,
    #   {
    #     uid: user.uid,
    #     info: { image: user.image_url },
    #     credentials: {
    #       token: 'hoge',
    #       refresh_token: 'hoge',
    #       expires_at: Time.zone.now.to_i
    #     }
    #   }
    # )
    # visit root_path
    # ensure_browser_size if Capybara.current_driver == :selenium_chrome_headless

    # click_on 'Discordでログイン'
    # @current_user = user
  end

  def current_user
    @current_user
  end

  def ensure_browser_size(width = 1400, height = 1400)
    Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
  end
end
