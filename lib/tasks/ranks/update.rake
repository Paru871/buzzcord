# frozen_string_literal: true

namespace :ranks do
  desc 'update ranking information'
  task update: :environment do
    RanksCreator.new.create_all
  end

  desc 'post buzzcord to discord channel'
  task post_buzzcord: :environment do
    formatter = BotMessageFormatter.new
    PostBuzzcord.post(formatter)
  end
end
