Rails.application.config.session_store :cookie_store, key: '_station_session', secure: Rails.env.production?
Rails.application.config.action_controller.forgery_protection_origin_check = false