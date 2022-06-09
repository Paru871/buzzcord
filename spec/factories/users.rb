# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider { 'discord' }
    uid { '1234567' }
    name { 'Mock' }
    discriminator { '1234' }
    avatar { 'https://cdn.discordapp.com/embed/avatars/3.png' }
  end
end
