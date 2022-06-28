# frozen_string_literal: true

namespace :ranks do
  desc 'create ranking information'
  task create: :environment do
    AllRankingDataCreator.call
  end

  desc 'post buzzcord to discord channel'
  task post_buzzcord: :environment do
    formatter = BotMessageFormatter.new
    PostBuzzcord.post(formatter)
  end
end
