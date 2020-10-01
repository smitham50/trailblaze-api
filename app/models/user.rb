class User < ApplicationRecord
    acts_as_token_authenticatable
    has_secure_password
    validates :password, confirmation: true
    geocoded_by :full_address

    after_update do |user|
        if user.address
            :geocode
        end
    end

    def full_address
        [address, city, state, zip].compact.join(', ')
    end
end
