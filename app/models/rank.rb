# frozen_string_literal: true

class Rank < ApplicationRecord
  has_many :emojis, dependent: :destroy
  has_many :attachments, dependent: :destroy
  serialize :content, Array
end
