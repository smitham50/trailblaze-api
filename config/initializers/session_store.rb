# frozen_string_literal: true
# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, key: '_station_session'

Rails.application.config.session_store(:active_record_store)

ActiveSupport.on_load(:active_record) do
  ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id
end