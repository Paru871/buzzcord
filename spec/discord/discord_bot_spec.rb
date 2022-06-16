# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordBot, type: :model do
  describe '#record' do
    it '有効なファクトリがあること' do
      expect(build(:reaction)).to be_valid
    end
    context 'botがリアクション絵文字の付加と削除を検知したとき' do
      it 'emoji_idがなくてもレコード作成が有効な状態であること' do
        reaction = build(:reaction, emoji_id: nil)
        reaction.valid?
        expect(reaction).to be_valid
      end
    end
  end

  describe '#member_watch' do
    context 'botがDiscordメンバーの退会と登録情報変更を検知したとき' do
      it '退会に合わせてUserレコード削除' do
        user_id = create(:user).uid
        user = User.find_by(uid: user_id)

        expect { user&.destroy }.to change { User.count }.from(1).to(0)
      end
    end

    context 'botがDiscordメンバーの退会と登録情報変更を検知したとき' do
      let(:uid) { create(:user).uid }
      before do
        regist_stub
      end

      it '情報変更に合わせてUserレコード更新' do
        updated_member = JSON.parse(Discordrb::API::User.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", uid))

        name = updated_member['username']
        discriminator = updated_member['discriminator']
        avatar = updated_member['avatar']

        user = User.find_by(uid: uid)
        expect do
          user.update!(name: name) if user.name != name
          user.update!(avatar: avatar) if user.avatar != avatar
          user.update!(discriminator: discriminator) if user.discriminator != discriminator
        end.to change { user.name }.from('Mock').to('zzz')
      end
    end
  end

  def regist_stub
    stub_request(:get, "#{Discordrb::API.api_base}/users/#{uid}").to_return(
      body: { "username": 'zzz', "discriminator": '1234', "avatar": 'https://cdn.discordapp.com/embed/avatars/3.png' }.to_json, status: 200
    )
  end
end

# サーバーからのイベント発生の合図をbotが検知するテストは現在はできないようなので今後も調査していく
