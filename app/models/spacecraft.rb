class Spacecraft < ApplicationRecord
  has_one :launch 
  has_one :launch_vehicle,through: :launch
  #validate :weight,numericality: {only_integer:true,lesser_than_or_equal_to: :sum_weight}
  # def sum_weight
    
  # end
end