class Satellite < ApplicationRecord
  puts "model class"
  belongs_to :launch_vehicle
  #validate :weight,numericality: {only_integer:true,lesser_than_or_equal_to: :sum_weight}
  # def sum_weight
    
  # end
end
