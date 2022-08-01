# frozen_string_literal: true

class RanksController < ApplicationController
  def index
    @ranks = Rank.includes(%i[emojis attachments]).order('ranks.order asc')
  end
end
