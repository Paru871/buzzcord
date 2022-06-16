# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmojisUpdater, type: :model do
  context '#emojis_update' do
    before do
      create_list(:reaction, 10)
      create_list(:reaction, 10, emoji_name: 'blob_cheer')
    end
    it '正確な数のemojiレコードが作成される' do
      rank_record = create(:rank)
      message = [[1_234_567, 11_111], 20]
      expect(Emoji.count).to eq 0
      EmojisUpdater.new.create_emojis(message, rank_record)
      expect(Emoji.count).to eq 2
    end
  end
end
