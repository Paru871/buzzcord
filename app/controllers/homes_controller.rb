# frozen_string_literal: true

class HomesController < ApplicationController
  skip_before_action :login_required

  def top; end
end
