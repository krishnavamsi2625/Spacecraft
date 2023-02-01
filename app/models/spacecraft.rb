class Spacecraft < ApplicationRecord
  belongs_to :launch_vehicle, optional: true
  validate :launch_vehicle_can_carry
  def sum_weight
    if(!launch_vehicle.reusable&&launch_vehicle.launches.find(launch_id).spacecrafts.any?)
      errors.add :launch_vehicle,:Vehicle_not_reusable,message:"Launch vehicle of type Non-Reusable"
      return
    end
    sum = launch.spacecraft.where.not(id: id).sum(:weight)
    sum+=weight
    if(sum>launch_vehicle.payload)
      errors.add :weight,:Vehicle_full,message:"Weight cannot be greater than payload"
    end 
  end
end
