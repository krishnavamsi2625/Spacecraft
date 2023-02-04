class Spacecraft < ApplicationRecord
  belongs_to :launch, optional: true
  has_many:launch_vehicle,through: :launch
  validate :launch_vehicle_can_carry
  def launch_vehicle_can_carry
    if(launch==nil)
      return
    end
    if(!launch.launch_vehicle.reusable&&launch.spacecrafts.any?)
      errors.add :launch_vehicle,:Vehicle_not_reusable,message:"Launch vehicle of type Non-Reusable"
      return
    end
    sum = launch.spacecrafts.where.not(id: id).sum(:weight)
    sum+=weight
    if(sum>launch.launch_vehicle.payload)
      errors.add :weight,:Vehicle_full,message:"Weight cannot be greater than payload"
    end 
  end
end
