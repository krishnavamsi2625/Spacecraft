class RenameSatellitesToSpacecrafts < ActiveRecord::Migration[7.0]
  def change
    rename_table :Satellites,:Spacecrafts
  end
end
