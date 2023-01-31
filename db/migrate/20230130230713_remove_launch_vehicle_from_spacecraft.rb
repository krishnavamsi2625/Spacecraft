class RemoveLaunchVehicleFromSpacecraft < ActiveRecord::Migration[7.0]
  def change
    remove_reference :spacecrafts,:launch_vehicle,index:true
  end
end
