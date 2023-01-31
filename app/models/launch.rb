class Launch < ApplicationRecord
  belongs_to :spacecraft
  belongs_to :launch_vehicle
end
