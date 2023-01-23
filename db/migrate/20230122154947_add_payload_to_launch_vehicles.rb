class AddPayloadToLaunchVehicles < ActiveRecord::Migration[7.0]
  def change
    add_column :launch_vehicles, :payload, :integer
  end
end
