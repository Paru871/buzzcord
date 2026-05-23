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

  describe '#reaction_create' do
    let(:discord_bot) { DiscordBot.new }
    let(:channel) { double('channel', id: 1_234_567) }
    let(:user) { double('user', id: 7_654_321) }
    let(:emoji) { double('emoji', name: 'test_emoji', id: nil) }
    let(:event) do
      double('event',
             channel: channel,
             message_id: 11_111,
             user: user,
             emoji: emoji)
    end

    before do
      allow(Discordrb::Bot).to receive(:new).and_return(double('discordrb_bot'))
    end

    it 'Reactionレコードが作成される' do
      expect { discord_bot.send(:reaction_create, event, 1) }.to change(Reaction, :count).by(1)
    end

    it 'event.channel.idとevent.message_idから属性を取得しevent.messageを呼ばない' do
      expect(event).not_to receive(:message)
      discord_bot.send(:reaction_create, event, 1)
      reaction = Reaction.last
      expect(reaction.channel_id).to eq 1_234_567
      expect(reaction.message_id).to eq 11_111
      expect(reaction.user_id).to eq 7_654_321
      expect(reaction.point).to eq 1
    end

    it 'リアクション削除はpointが-1で保存される' do
      discord_bot.send(:reaction_create, event, -1)
      expect(Reaction.last.point).to eq(-1)
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
        updated_member = JSON.parse(DiscordApiClient.new.fetch_user_info(uid))

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
