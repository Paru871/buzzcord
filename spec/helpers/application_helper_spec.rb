# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context '#make_contents_all' do
    it '全投稿内容が文字列として連結する' do
      rank = create(:rank, content: ['🙏 ', [':819:', '9883'], ' 👍 '])
      # rubocop:disable Layout/LineLength
      expect(helper.make_contents_all(rank.content)).to eq("🙏 <img alt=':819:' aria-label=':819:' class='emoji' data-id='9883' data-type='emoji' draggable='false' src='https://cdn.discordapp.com/emojis/9883.webp?size=32&amp;quality=lossless'> 👍 ")
      # rubocop:enable Layout/LineLength
    end
  end
end
