# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome', type: :system do
  let(:user) { create(:user) }

  it 'ユーザがログインできる' do
    login_user user
    expect(page).to have_content 'ログインしました。'
    expect(page).to have_content 'のBuzzcordランキング一覧'
  end

  it 'ログインしているユーザがログアウトできる' do
    login_user user
    # find('.navbar-link').hover
    click_on 'ログアウト'

    expect(page).to have_content 'ログアウトしました。'
    expect(page).to have_content 'Discordサーバー内で昨日バズった発言のランキングをチェック！'
  end

  it 'ログインしていないユーザが / ページを表示' do
    visit root_path

    expect(page).to have_content 'Discordサーバー内で昨日バズった発言のランキングをチェック！'
  end

  it 'ログインしているユーザが / ページを表示' do
    login_user user
    visit root_path

    expect(page).to have_content 'のBuzzcordランキング一覧'
  end
end
