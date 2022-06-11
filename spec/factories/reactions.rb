# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    channel_id { 1234567 }
    message_id { 12345 }
    user_id { 7654321 }
    emoji_name { 'emoji' }
    emoji_id { '' }
    reacted_at { Time.current.yesterday }
    point { 1 }

    trait :m1e1 do
      message_id { 11111 }
      emoji_name { 'emoji1' }
    end

    trait :m1e2 do
      message_id { 11111 }
      emoji_name { 'emoji2' }
    end

    trait :m1e3 do
      message_id { 11111 }
      emoji_name { 'emoji3' }
    end

    trait :m1e4 do
      message_id { 11111 }
      emoji_name { 'emoji4' }
    end

    trait :m2e1 do
      message_id { 11112 }
      emoji_name { 'emoji1' }
    end

    trait :m2e2 do
      message_id { 11112 }
      emoji_name { 'emoji2' }
    end

    trait :m2e3 do
      message_id { 11112 }
      emoji_name { 'emoji3' }
    end

    trait :m2e4 do
      message_id { 11112 }
      emoji_name { 'emoji4' }
    end

    trait :m3e1 do
      message_id { 11113 }
      emoji_name { 'emoji1' }
    end

    trait :m3e2 do
      message_id { 11113 }
      emoji_name { 'emoji2' }
    end

    trait :m3e3 do
      message_id { 11113 }
      emoji_name { 'emoji3' }
    end

    trait :m3e4 do
      message_id { 11113 }
      emoji_name { 'emoji4' }
    end


    trait :m4e1 do
      message_id { 11114 }
      emoji_name { 'emoji1' }
    end

    trait :m4e2 do
      message_id { 11114 }
      emoji_name { 'emoji2' }
    end

    trait :m4e3 do
      message_id { 11114 }
      emoji_name { 'emoji3' }
    end

    trait :m4e4 do
      message_id { 11114 }
      emoji_name { 'emoji4' }
    end

    trait :m5e1 do
      message_id { 11115 }
      emoji_name { 'emoji1' }
    end

    trait :m5e2 do
      message_id { 11115 }
      emoji_name { 'emoji2' }
    end

    trait :m5e3 do
      message_id { 11115 }
      emoji_name { 'emoji3' }
    end

    trait :m5e4 do
      message_id { 11115 }
      emoji_name { 'emoji4' }
    end

    trait :m6e1 do
      message_id { 11116 }
      emoji_name { 'emoji1' }
    end

    trait :m6e2 do
      message_id { 11116 }
      emoji_name { 'emoji2' }
    end

    trait :m6e3 do
      message_id { 11116 }
      emoji_name { 'emoji3' }
    end

    trait :m6e4 do
      message_id { 11116 }
      emoji_name { 'emoji4' }
    end

    trait :m7e1 do
      message_id { 11117 }
      emoji_name { 'emoji1' }
    end

    trait :m7e2 do
      message_id { 11117 }
      emoji_name { 'emoji2' }
    end

    trait :m7e3 do
      message_id { 11117 }
      emoji_name { 'emoji3' }
    end

    trait :m7e4 do
      message_id { 11117 }
      emoji_name { 'emoji4' }
    end

    trait :m8e1 do
      message_id { 11118 }
      emoji_name { 'emoji1' }
    end

    trait :m8e2 do
      message_id { 11118 }
      emoji_name { 'emoji2' }
    end

    trait :m8e3 do
      message_id { 11118 }
      emoji_name { 'emoji3' }
    end

    trait :m8e4 do
      message_id { 11118 }
      emoji_name { 'emoji4' }
    end

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
