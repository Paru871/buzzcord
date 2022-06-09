# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_from_auth_hash' do
    before do
      @uid = '123456'
      stub_request(:get, "#{Discordrb::API.api_base}/guilds/#{ENV['DISCORD_SERVER_ID']}/members/#{@uid}")
    end

    let(:auth_hash) do
      {
        provider: 'discord',
        uid: @uid,
        info: {
          name: 'carol'
        },
        extra: {
          raw_info: {
            discriminator: '1234'
          }
        }
      }
    end

    context 'uidに対応するUserが作成されていないとき' do
      it '引数で設定した属性のUserオブジェクトが返ること' do
        user = User.find_or_create_from_auth_hash!(auth_hash)
        expect(user.provider).to eq 'discord'
        expect(user.uid).to eq '123456'
        expect(user.name).to eq 'carol'
        expect(user.discriminator).to eq '1234'
        expect(User.find_or_create_from_auth_hash!(auth_hash)).to eq User.find_by(uid: @uid)
        expect(user).to be_persisted
      end

      it 'Userモデルのレコードが一件増えていること' do
        expect { User.find_or_create_from_auth_hash!(auth_hash) }.to change { User.count }.from(0).to(1)
      end
    end

    context 'uidに対応するUserが既に作成されているとき' do
      let!(:created_user) { FactoryBot.create(:user, uid: @uid) }

      it '引数に対応するUserレコードのオブジェクトが返ること' do
        user = User.find_or_create_from_auth_hash!(auth_hash)
        expect(user).to eq created_user
      end

      it 'Userモデルのレコード件数が変化していないこと' do
        expect { User.find_or_create_from_auth_hash!(auth_hash) }.not_to change(User, :count)
      end
    end
  end
end
