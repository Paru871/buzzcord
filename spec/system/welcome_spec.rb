# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome', type: :system do

  let(:user) { create(:user) }

  it 'ユーザがログインできる' do
    sign_in_as(user)

    expect(page).to have_content 'ログインしました。'
    expect(page).to have_content 'のランキング'
  end

  it 'ログインしているユーザがログアウトできる' do
    sign_in_as(user)
    click_on 'ログアウト'

    expect(page).to have_content 'ログアウトしました。'
    expect(page).to have_content 'Buzzcordは昨日Discordのサーバーでバズった発言をDiscord botが自動で集計・紹介。'
  end

  it 'ログインしていないユーザが / ページを表示' do
    visit root_path

    expect(page).to have_content 'Buzzcordは昨日Discordのサーバーでバズった発言をDiscord botが自動で集計・紹介。'
  end

  it 'ログインしているユーザが / ページを表示' do
    sign_in_as(user)
    visit root_path

    expect(page).to have_content 'のランキング'
  end
end
