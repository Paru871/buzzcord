# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.find_or_create_from_auth_hash!' do
    let(:auth_hash) do
      {
        provider: 'discord',
        uid: '572729242928939017',
        info: {
          name: 'Buzzcord'
        },
        extra: {
          raw_info: {
            avatar: '5555',
            discriminator: '1234'
          }
        }
      }
    end

    context 'uidに対応するUserが作成されていないとき' do
      it '引数で設定した属性のUserオブジェクトが返ること' do
        user = User.find_or_create_from_auth_hash!(auth_hash)
        expect(user.provider).to eq 'discord'
        expect(user.uid).to eq '572729242928939017'
        expect(user.name).to eq 'Buzzcord'
        expect(user.avatar).to eq 'https://cdn.discordapp.com/avatars/572729242928939017/5555.webp'
        expect(user.discriminator).to eq '1234'
        expect(user).to be_persisted
      end

      it 'Userモデルのレコードが一件増えていること' do
        expect { User.find_or_create_from_auth_hash!(auth_hash) }.to change { User.count }.from(0).to(1)
      end
    end

    context 'uidに対応するUserが既に作成されているとき' do
      let!(:created_user) { FactoryBot.create(:user, uid: '572729242928939017') }

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
