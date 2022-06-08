# frozen_string_literal: true

require_relative '../sign_in_helper'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
