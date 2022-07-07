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
      expect(page).to have_selector('.rank-main__title', text: 'Hana', count: 5)
    end

    it 'ランキングと表示内容の一致の確認' do
      sign_in_as(user)
      element = all('.rank').find { |component| component.has_selector?('.is-rank-1') }
      within element do
        expect(page).to have_selector '.rank-main__text.card-text', text: 'テスト投稿です！_1'
      end
      element = all('.rank').find { |component| component.has_selector?('.is-rank-2') }
      within element do
        expect(page).to have_selector '.rank-main__text.card-text', text: 'テスト投稿です！_2'
      end
      element = all('.rank').find { |component| component.has_selector?('.is-rank-3') }
      within element do
        expect(page).to have_selector '.rank-main__text.card-text', text: 'テスト投稿です！_3'
      end
      element = all('.rank').find { |component| component.has_selector?('.is-rank-4') }
      within element do
        expect(page).to have_selector '.rank-main__text.card-text', text: 'テスト投稿です！_4'
      end
      element = all('.rank').find { |component| component.has_selector?('.is-rank-5') }
      within element do
        expect(page).to have_selector '.rank-main__text.card-text', text: 'テスト投稿です！_5'
      end
    end

    let(:ranks) { page.all('.rank') }
    it 'レコード順を保持している' do
      sign_in_as(user)

      expect(ranks[0].find('.rank-main__text.card-text').text).to eq 'テスト投稿です！_1'
      expect(ranks[1].find('.rank-main__text.card-text').text).to eq 'テスト投稿です！_2'
      expect(ranks[2].find('.rank-main__text.card-text').text).to eq 'テスト投稿です！_3'
      expect(ranks[3].find('.rank-main__text.card-text').text).to eq 'テスト投稿です！_4'
      expect(ranks[4].find('.rank-main__text.card-text').text).to eq 'テスト投稿です！_5'
    end
  end
end
