# frozen_string_literal: true

Rails.application.config.session_store :redis_session_store, {
    key: '_be_free_session',
    serializer: :json,
    domain: :all,
    tld_length: "#{2 if  Rails.env.production?}",
    redis: {
      expire_after: 1.week,
      key_prefix: 'be_free:session',
      url: ENV['REDIS_URL']
    }
  }
  