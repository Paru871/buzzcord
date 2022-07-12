# frozen_string_literal: true

module MetaTagsHelper
  # rubocop:disable Metrics/MethodLength
  def default_meta_tags
    {
      site: 'Buzzcord',
      title: 'Buzzcord',
      reverse: true,
      charset: 'utf-8',
      description: 'Discordで昨日バズった発言を知るアプリ',
      canonical: 'https://buzzcord.herokuapp.com/',
      viewport: 'width=device-width, initial-scale=1.0',
      og: {
        title: 'Buzzcord',
        type: 'website',
        site_name: 'Buzzcord',
        description: :description,
        image: image_url('ogp.png'),
        url: 'https://buzzcord.herokuapp.com/',
        locale: 'ja_JP'
      },
      twitter: {
        title: 'Buzzcord',
        card: 'summary_large_image',
        site: '@Paru871',
        description: :description,
        image: image_url('ogp.png'),
        domain: 'https://buzzcord.herokuapp.com/'
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
