# frozen_string_literal: true

class RankOrderMaker
  def each_ranked_message(&block)
    Reaction
      .where(reacted_at: Time.zone.yesterday.all_day)
      .order(sum_point: :desc).order(:message_id)
      .group(:channel_id, :message_id).sum(:point)
      .first(5).each.with_index(1, &block)
  end
end
