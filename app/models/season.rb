class Season < ApplicationRecord
    has_many :videos, class_name: "video"
end
