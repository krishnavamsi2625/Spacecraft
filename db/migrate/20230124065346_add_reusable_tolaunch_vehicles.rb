class AddReusableTolaunchVehicles < ActiveRecord::Migration[7.0]
  def change
  add_column :launch_vehicles,:reusable,:boolean
  end
end
