# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider { 'discord' }
    uid { '1234567' }
    name { 'Mock User' }
    discriminator { '1234' }
    avatar { '98765' }
  end
end
