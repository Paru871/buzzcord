# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    rank_id { 1 }
    attachment_id { 123_456 }
    attachment_filename { '55555.png' }
  end
end
