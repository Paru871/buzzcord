# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RanksCreator, type: :model do
  describe '#call' do
    context 'Rankのレコードを作成する' do
      it 'Rankレコードが作成される' do
        rank = create(:rank)
        create(:emoji, rank_id: rank.id)
        create(:attachment, rank_id: rank.id)
        expect { Rank.delete_all }
          .to change { Rank.count }.from(1).to(0)
          .and change { Emoji.count }.from(1).to(0)
          .and change { Attachment.count }.from(1).to(0)
      end
      it '順位が正確に保存されている' do
      end
    end
  end
end
