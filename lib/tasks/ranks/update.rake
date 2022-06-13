# frozen_string_literal: true

namespace :ranks do
  desc 'update ranking information'
  task update: :environment do
    RanksUpdater.new.update_all
  end

  desc 'post buzzcord to discord channel'
  task post_buzzcord: :environment do
<<<<<<< HEAD
    formatter = BotMessageFormatter.new
    PostBuzzcord.post(formatter)
=======
    formatter = BotMessageFormatter.new(channel)
    PostBuzzcord.new.post(formatter)
>>>>>>> 01df605 (Discordへのお知らせ投稿のテストを作成中)
  end
end
