class CreateLaunches < ActiveRecord::Migration[7.0]
  def change
    create_table :launches do |t|
      t.datetime :launch_date
      t.references :launch_vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
