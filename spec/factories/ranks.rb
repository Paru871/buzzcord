# frozen_string_literal: true

FactoryBot.define do
  factory :rank do
    order { 1 }
    channel_id { 12_345 }
    channel_name { '趣味の広場' }
    thread_id { 23_456 }
    thread_name { '音楽' }
    message_id { 34_567 }
    content { ['テスト投稿です！'] }
    author_id { 45_678 }
    author_name { 'Hana' }
    author_avatar { 'https://cdn.discordapp.com/embed/avatars/3.png' }
    author_discriminator { 5678 }
    posted_at { '2022-06-13 21:00:00' }
    total_emojis_count { 20 }
    content_post { 'テスト投稿です！' }
  end
end
