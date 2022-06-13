# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordBot, type: :model do
  # botがDiscordサーバーに常駐してイベントに反応する動作をテストしたい
  # 「イベントに反応する」というきっかけをテストで表現する方法が見つからないため今後も継続調査します。

  describe '#record' do
    context 'リアクション絵文字の付加イベントにbotが反応したとき' do
      it 'reactionのポイント1のレコードが1件増える' do
      end
    end

    context 'リアクション絵文字の削除イベントにbotが反応したとき' do
      it 'reactionのポイント-1のレコードが1件増える' do
      end
    end
  end

  describe '#member_watch' do
    context 'ユーザー情報の更新にbotが反応したとき' do
      it 'ユーザーのレコードが更新される' do
      end
    end

    context 'ユーザーのサーバーからの削除にbotが反応したとき' do
      it 'レコードからユーザーの削除が行われる' do
      end
    end
  end
end
