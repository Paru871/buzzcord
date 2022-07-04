# frozen_string_literal: true

class AllRankingDataCreator
  def self.call
    # 現在のランキング情報をリセット
    Rank.delete_all

    # 発言ごとに昨日ついた絵文字合計で降順に並べ替え、そこからランキング情報を再作成する
    RankOrderMaker.new.each_ranked_message do |message, index|
      rank_record = RanksCreator.call(message, index)
      EmojisCreator.call(message, rank_record)
      AttachmentsCreator.call(message, rank_record)
    end
  end
end
