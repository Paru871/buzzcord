# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  before do
    stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}").to_return(body: { "name": 'ABC' }.to_json, status: 200)
  end

  let(:user) { FactoryBot.create(:user) }

  it 'ユーザがログインできる' do
    sign_in_as(user)

    expect(page).to have_content 'ログインしました。'
    expect(page).to have_content 'のBuzzcordランキング一覧'
  end

  it 'ログインしているユーザがログアウトできる' do
    sign_in_as(user)
    click_on 'ログアウト'

    expect(page).to have_content 'ログアウトしました。'
    expect(page).to have_content 'Discordサーバー内で昨日バズった発言のランキングをチェック！'
  end

  it 'ログインしていないユーザが / ページを表示' do
    visit root_path

    expect(page).to have_content 'Discordサーバー内で昨日バズった発言のランキングをチェック！'
  end

  it 'ログインしているユーザが / ページを表示' do
    sign_in_as(user)
    visit root_path

    expect(page).to have_content 'のBuzzcordランキング一覧'
  end
end
