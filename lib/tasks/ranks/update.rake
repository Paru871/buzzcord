# frozen_string_literal: true

namespace :ranks do
  desc '昨日のリアクション絵文字獲得数をもとにランキング情報を更新する'
  task update: :environment do
    RanksUpdater.new.update_all
  end
end
