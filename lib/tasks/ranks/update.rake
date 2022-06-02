# frozen_string_literal: true

namespace :ranks do
  desc 'update ranking information'
  task update: :environment do
    RanksUpdater.new.update_all
  end

  desc 'post buzzcord to discord channel'
  task post_buzzcord: :environment do
    PostBuzzcord.new.post
  end
end
