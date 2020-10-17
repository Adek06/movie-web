class Show < ApplicationRecord
    has_many :seasons, class_name: "season"
end
