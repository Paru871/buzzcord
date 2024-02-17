# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    rank_id { 1 }
    attachment_id { 123_456 }
    attachment_filename { 'https://cdn.discordapp.com/attachments/23456/123456/55555.png' }
  end
end
