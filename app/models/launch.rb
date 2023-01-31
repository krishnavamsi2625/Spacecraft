class Launch < ApplicationRecord
  has_many :spacecraft
  belongs_to :launch_vehicle
end
