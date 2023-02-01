class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :Spacecrafts, :launch_date, :expected_launch_date
  end
end
