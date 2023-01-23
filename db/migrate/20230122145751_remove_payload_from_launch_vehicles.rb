class RemovePayloadFromLaunchVehicles < ActiveRecord::Migration[7.0]
  def change
    remove_column :launch_vehicles, :payload, :integer
  end
end
