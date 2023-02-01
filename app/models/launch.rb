class Launch < ApplicationRecord
  has_many :spacecrafts
  belongs_to :launch_vehicle
  
end
