# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RankOrderMaker, type: :model do
  describe '#each_ranked_message' do
    context 'リアクション数の降順に並べ替えて上位5位が取得できる' do
      before do
        1.upto(8).each do |n|
          create_list(:reaction, n, message_id: n)
        end
      end

      it '5件取得できる' do
        ranks = {}
        RankOrderMaker.new.each_ranked_message do |message, index|
          ranks[message[0][1]] = index
        end

        expect(ranks.size).to eq 5
      end

      it 'データ数(絵文字獲得数)が多い順に取得できる' do
        ranks = []
        RankOrderMaker.new.each_ranked_message do |message, _index|
          ranks.push(message[1])
        end

        expect(ranks.sort.reverse).to eq ranks
      end
    end

    context '日付の絞り込みを確認する' do
      before do
        create_list(:reaction, 10)
        create_list(:reaction, 10, :reacted_before_yesterday)
        create_list(:reaction, 10, :reacted_today)
      end

      it '昨日のデータのみが残る' do
        number = 0
        RankOrderMaker.new.each_ranked_message do |message, _index|
          number += message[1]
        end
        expect(number).to eq 10
      end
    end

    context '絵文字削除のアクションへの対応確認' do
      before do
        create_list(:reaction, 10)
        create_list(:reaction, 5, :remove)
      end

      it '削除が計算に反映されている' do
        number = 0
        RankOrderMaker.new.each_ranked_message do |message, _index|
          number += message[1]
        end
        expect(number).to eq 5
      end
    end
  end
end
