# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    mock_discord!
  end

  describe 'ログイン処理' do
    context '認証が成功した時' do
      it 'ログインができる' do
        visit root_path
        click_on('Discordでログイン')
        expect(page).to have_content('ログインしました。')
      end
    end
    context '認証が失敗した時' do
      before { mock_discord_failure! }
      it 'ログインができない' do
        visit root_path
        click_on('Discordでログイン')
        expect(page).to have_content('ログインできませんでした。')
      end
    end
  end

  describe 'ログアウト処理' do
    before do
      visit root_path
      find_link('Discordでログイン', href: '/auth/discord').click
      find('.logout-link').click
    end
    it 'ログアウトができること' do
      expect(page).to have_content('ログアウトしました。')
    end
  end

  describe 'ログイン状態による画面表示の確認' do
    context 'ログインしていない場合' do
      it 'root_pathにアクセスするとhomes画面に遷移すること' do
        visit root_path
        expect(page).to have_content('Discordサーバー内で昨日バズった発言のランキングをチェック！')
      end
      # it 'code新規作成画面に遷移できず、代わりにwelcome画面に遷移すること' do
      #   visit new_code_path
      #   expect(page).to have_content('discordでちょっとしたCodeを共有')
      # end
    end
    context 'ログインしている場合' do
      before do
        visit root_path
        find_link('Discordでログイン', href: '/auth/discord').click
      end
      it 'ランキング一覧ページが表示されること' do
        expect(page).to have_content('のBuzzcordランキング一覧')
      end
      it 'ログアウトボタンが表示されていること' do
        expect(page).to have_button('ログアウト')
      end
    end
  end
end
