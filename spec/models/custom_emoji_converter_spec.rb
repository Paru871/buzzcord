# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomEmojiConverter, type: :model do
  describe '#call' do
    context 'カスタム絵文字が含まれる投稿文' do
      it 'カスタム絵文字はURLに変換されて文字列に格納される' do
        content = 'こんにちは！🎉 今日も暑かった！<:9666:9883> 😍'
        contents_all = CustomEmojiConverter.call(content)
        # rubocop:disable Layout/LineLength
        expect(contents_all).to eq "こんにちは！🎉 今日も暑かった！<img alt=':9666:' aria-label=':9666:' class='emoji' data-id='9883' data-type='emoji' draggable='false' src='https://cdn.discordapp.com/emojis/9883.webp?size=32&amp;quality=lossless'> 😍"
        # rubocop:enable Layout/LineLength
      end
    end

    context 'カスタム絵文字が含まれない投稿文' do
      it 'そのまま文字列に格納される' do
        content = 'こんにちは！🎉 今日も暑かった！😍'
        contents_all = CustomEmojiConverter.call(content)
        expect(contents_all).to eq 'こんにちは！🎉 今日も暑かった！😍'
      end
    end
  end
end
