# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RanksUpdater, type: :model do
  describe '#convert_custom_emoji' do
    context '投稿文にカスタム絵文字があれば区切る' do
      regexp = /(<:[a-z]+:[0-9]+>)/
      regexp2 = /<(:[a-z]+:)([0-9]+)>/
      content = '絵文字チェックです<:iine:975374141161082901> 😊'
      content2 = ['絵文字チェックです', [':iine:', '975374141161082901'], ' 😊']
      content3 = '絵文字チェックです😊'
      content4 = ['絵文字チェックです😊']

      it 'カスタム絵文字がある場合は分割して配列を作成する' do
        answer =
          content.split(regexp).map do |word|
            matched = word.match(regexp2)
            matched ? [matched[1], matched[2]] : word
          end
        expect(answer).to eq content2
      end

      it 'カスタム絵文字がない場合はそのまま配列に入れる' do
        answer =
          content3.split(regexp).map do |word|
            matched = word.match(regexp2)
            matched ? [matched[1], matched[2]] : word
          end
        expect(answer).to eq content4
      end
    end
  end
end
