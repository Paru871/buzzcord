# frozen_string_literal: true

class CustomEmojiConverter
  def self.call(content)
    regexp = /(<:[0-9a-zA-Z_]+:[0-9]+>)/
    regexp2 = /<(:[0-9a-zA-Z_]+:)([0-9]+)>/
    contents_all = +''
    content.split(regexp).map do |word|
      matched = word.match(regexp2)
      if matched
        contents_all += "<img alt='#{matched[1]}' aria-label='#{matched[1]}' class='emoji' data-id='#{matched[2]}' data-type='emoji' draggable='false' src='https://cdn.discordapp.com/emojis/#{matched[2]}.webp?size=32&amp;quality=lossless'>"
      else
        contents_all += word
      end
    end
    contents_all
  end
end
