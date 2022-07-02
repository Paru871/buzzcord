# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvatarUrlMaker, type: :model do
  describe '#call' do
    context 'avatar_idがあるとき' do
      before do
        @uid = '1234567'
        @avatar_id = '333'
        @discriminator = '1234'
      end
      it 'アバターURLが取得できる' do
        avatar_url = AvatarUrlMaker.call(@uid, @avatar_id, @discriminator)
        expect(avatar_url).to eq 'https://cdn.discordapp.com/avatars/1234567/333.webp'
      end
    end
    context 'avatar_idがnilのとき' do
      before do
        @uid = '1234567'
        @avatar_id = nil
        @discriminator = '1234'
      end
      it 'デフォルト画像を取得する' do
        avatar_url = AvatarUrlMaker.call(@uid, @avatar_id, @discriminator)
        expect(avatar_url).to eq 'https://cdn.discordapp.com/embed/avatars/4.png'
      end
    end
  end
end
