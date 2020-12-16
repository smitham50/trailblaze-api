Rails.application.config.session_store :cookie_store, key: '_station_session'

ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id