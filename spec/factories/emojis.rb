# frozen_string_literal: true

FactoryBot.define do
  factory :emoji do
    rank_id { 1 }
    emoji_name { ':tada:' }
    emoji_id { '' }
    count { 2 }
  end
end
