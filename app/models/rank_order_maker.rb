# frozen_string_literal: true

class RankOrderMaker
  def each_ranked_message
    messages_sorted_by_points.first(5).each.with_index(1) do |message, index|
      yield(message, index)
    end
  end

  private

  def messages_sorted_by_points
    Reaction
      .where(reacted_at: Time.zone.yesterday.all_day)
      .order(sum_point: :desc).order(:message_id)
      .group(:channel_id, :message_id).sum(:point)
  end
end
