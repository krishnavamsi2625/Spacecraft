class CreateLaunchVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :launch_vehicles do |t|
      t.string :name
      t.integer :weight
      t.string :owned_by

      t.timestamps
    end
  end
end
