# frozen_string_literal: true

class RanksController < ApplicationController
  def index
    @ranks = Rank.all
  end
end
