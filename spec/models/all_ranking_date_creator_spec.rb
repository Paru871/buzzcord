# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RanksCreator, type: :model do
  describe '#call' do
    context '#delete_all Rankのレコードを全削除するとき' do
      it 'RankレコードとともにEmojiとAttachmentレコードも削除される' do
        rank = create(:rank)
        create(:emoji, rank_id: rank.id)
        create(:attachment, rank_id: rank.id)
        expect { Rank.delete_all }
          .to change { Rank.count }.from(1).to(0)
          .and change { Emoji.count }.from(1).to(0)
          .and change { Attachment.count }.from(1).to(0)
      end
    end
    context 'create all  ranking data' do
      it 'Reactionデータを集計し、新しいテーブル3つにレコードを保存する' do
      end
    end
  end
end
