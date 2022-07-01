# frozen_string_literal: true

require 'csv'

CSV.foreach('db/reactions.csv', headers: true) do |row|
  Reaction.new(
    id: row['id'],
    channel_id: row['channel_id'],
    message_id: row['message_id'],
    user_id: row['user_id'],
    emoji_name: row['emoji_name'],
    emoji_id: row['emoji_id'],
    reacted_at: row['reacted_at'],
    created_at: row['created_at'],
    updated_at: row['updated_at'],
    point: row['point']
  ).save!(validate: false)
end

CSV.foreach('db/ranks.csv', headers: true) do |row|
  Rank.new(
    id: row['id'],
    order: row['order'],
    channel_id: row['channel_id'],
    channel_name: row['channel_name'],
    thread_id: row['thread_id'],
    thread_name: row['thread_name'],
    message_id: row['message_id'],
    content: row['content'],
    author_id: row['author_id'],
    author_name: row['author_name'],
    author_avatar: row['author_avatar'],
    author_discriminator: row['author_discriminator'],
    created_at: row['created_at'],
    updated_at: row['updated_at'],
    posted_at: row['posted_at'],
    total_emojis_count: row['total_emojis_count'],
    content_post: row['content_post']
  ).save!(validate: false)
end

CSV.foreach('db/attachments.csv', headers: true) do |row|
  Attachment.new(
    id: row['id'],
    rank_id: row['rank_id'],
    attachment_id: row['attachment_id'],
    attachment_filename: row['attachment_filename'],
    created_at: row['created_at'],
    updated_at: row['updated_at']
  ).save!(validate: false)
end

CSV.foreach('db/emojis.csv', headers: true) do |row|
  Emoji.new(
    id: row['id'],
    rank_id: row['rank_id'],
    emoji_name: row['emoji_name'],
    emoji_id: row['emoji_id'],
    count: row['count'],
    created_at: row['created_at'],
    updated_at: row['updated_at']
  ).save!(validate: false)
end
