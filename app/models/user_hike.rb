class UserHike < ApplicationRecord
  belongs_to :user
  belongs_to :hike, optional: true, class_name: "Trail"
end