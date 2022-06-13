# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    channel_id { 1_234_567 }
    message_id { 11_111 }
    user_id { 7_654_321 }
    emoji_name { 'emoji' }
    emoji_id { '' }
    reacted_at { Time.current.yesterday }
    point { 1 }

    trait :reacted_before_yesterday do
      reacted_at { Time.current.ago(3.days) }
    end

    trait :reacted_today do
      reacted_at { Time.current }
    end

    trait :remove do
      point { -1 }
    end
  end
end
