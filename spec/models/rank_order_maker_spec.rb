# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RankOrderMaker, type: :model do
  describe '#each_ranked_message' do
    before do
      create_list(:reaction, 2, :m1e1)
      create_list(:reaction, 2, :m1e2)
      create_list(:reaction, 2, :m1e3)
      create_list(:reaction, 2, :m1e4)
      create_list(:reaction, 2, :m1e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m1e1, :reacted_today)
      create_list(:reaction, 1, :m1e1, :remove)

      create_list(:reaction, 2, :m2e1)
      create_list(:reaction, 2, :m2e2)
      create_list(:reaction, 2, :m2e3)
      create_list(:reaction, 3, :m2e4)
      create_list(:reaction, 2, :m2e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m2e1, :reacted_today)
      create_list(:reaction, 1, :m2e1, :remove)

      create_list(:reaction, 1, :m3e1)
      create_list(:reaction, 2, :m3e2)
      create_list(:reaction, 2, :m3e3)
      create_list(:reaction, 2, :m3e4)
      create_list(:reaction, 2, :m3e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m3e1, :reacted_today)
      create_list(:reaction, 1, :m3e1, :remove)

      create_list(:reaction, 2, :m4e1)
      create_list(:reaction, 2, :m4e2)
      create_list(:reaction, 3, :m4e3)
      create_list(:reaction, 3, :m4e4)
      create_list(:reaction, 2, :m4e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m4e1, :reacted_today)
      create_list(:reaction, 1, :m4e1, :remove)

      create_list(:reaction, 1, :m5e1)
      create_list(:reaction, 1, :m5e2)
      create_list(:reaction, 2, :m5e3)
      create_list(:reaction, 2, :m5e4)
      create_list(:reaction, 2, :m5e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m5e1, :reacted_today)
      create_list(:reaction, 1, :m5e1, :remove)

      create_list(:reaction, 2, :m6e1)
      create_list(:reaction, 3, :m6e2)
      create_list(:reaction, 3, :m6e3)
      create_list(:reaction, 3, :m6e4)
      create_list(:reaction, 2, :m6e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m6e1, :reacted_today)
      create_list(:reaction, 1, :m6e1, :remove)

      create_list(:reaction, 1, :m7e1)
      create_list(:reaction, 1, :m7e2)
      create_list(:reaction, 1, :m7e3)
      create_list(:reaction, 2, :m7e4)
      create_list(:reaction, 2, :m7e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m7e1, :reacted_today)
      create_list(:reaction, 1, :m7e1, :remove)

      create_list(:reaction, 3, :m8e1)
      create_list(:reaction, 3, :m8e2)
      create_list(:reaction, 3, :m8e3)
      create_list(:reaction, 3, :m8e4)
      create_list(:reaction, 2, :m8e1, :reacted_before_yesterday)
      create_list(:reaction, 2, :m8e1, :reacted_today)
      create_list(:reaction, 1, :m8e1, :remove)
    end

    it '昨日のリアクション数の降順に並べ替えて上位5位が取得できる' do
      ranks = {}

      RankOrderMaker.new.each_ranked_message do |message, index|
        ranks[message[0][1]] = index
      end

      expect(ranks.size).to eq 5
      expect(ranks[11118]).to eq 1
      expect(ranks[11116]).to eq 2
      expect(ranks[11114]).to eq 3
      expect(ranks[11112]).to eq 4
      expect(ranks[11111]).to eq 5
    end

    it '昨日取得した総絵文字ポイントを取得できる' do
      ranks = {}

      RankOrderMaker.new.each_ranked_message do |message, index|
        ranks[message[0][1]] = message[1]
      end

      expect(ranks.size).to eq 5
      expect(ranks[11118]).to eq 11
      expect(ranks[11116]).to eq 10
      expect(ranks[11114]).to eq 9
      expect(ranks[11112]).to eq 8
      expect(ranks[11111]).to eq 7
    end
  end
end
