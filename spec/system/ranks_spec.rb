# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ranks', type: :system do
  describe 'ランキング一覧の表示' do
    before do
      rank = []
      1.upto(5).each do |n|
        rank[n] = create(:rank, order: n, content: "テスト投稿です！_#{n}")
      end
    end

    let(:user) { create(:user) }

    it '表示件数の確認' do
      sign_in_as(user)

      expect(page).to have_content 'のランキング'
      expect(page).to have_selector('.card-title', text: 'Hana', count: 5)
    end

    it 'ランキングと表示内容の一致の確認' do
      sign_in_as(user)
      element = all('.card').find { |component| component.has_text?('1位') }
      within element do
        expect(page).to have_selector '.rank-text.card-text', text: 'テスト投稿です！_1'
      end
      element = all('.card').find { |component| component.has_text?('2位') }
      within element do
        expect(page).to have_selector '.rank-text.card-text', text: 'テスト投稿です！_2'
      end
      element = all('.card').find { |component| component.has_text?('3位') }
      within element do
        expect(page).to have_selector '.rank-text.card-text', text: 'テスト投稿です！_3'
      end
      element = all('.card').find { |component| component.has_text?('4位') }
      within element do
        expect(page).to have_selector '.rank-text.card-text', text: 'テスト投稿です！_4'
      end
      element = all('.card').find { |component| component.has_text?('5位') }
      within element do
        expect(page).to have_selector '.rank-text.card-text', text: 'テスト投稿です！_5'
      end
    end

    let(:cards) { page.all('.card') }
    it 'レコード順を保持している' do
      sign_in_as(user)

      expect(cards[0].find('.rank-text.card-text').text).to eq 'テスト投稿です！_1'
      expect(cards[1].find('.rank-text.card-text').text).to eq 'テスト投稿です！_2'
      expect(cards[2].find('.rank-text.card-text').text).to eq 'テスト投稿です！_3'
      expect(cards[3].find('.rank-text.card-text').text).to eq 'テスト投稿です！_4'
      expect(cards[4].find('.rank-text.card-text').text).to eq 'テスト投稿です！_5'
    end
  end
end
