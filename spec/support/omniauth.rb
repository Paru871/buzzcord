# frozen_string_literal: true

OmniAuth.config.test_mode = true
WebMock.allow_net_connect!
OmniAuth.config.on_failure = proc { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
