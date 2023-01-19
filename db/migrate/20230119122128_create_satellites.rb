class CreateSatellites < ActiveRecord::Migration[7.0]
  def change
    create_table :satellites do |t|
      t.string :name
      t.integer :weight
      t.date :launch_date
      t.string :owned_by
      t.references :launch_vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
