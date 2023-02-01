class AddPayloadToLaunch < ActiveRecord::Migration[7.0]
  def change
    add_column :launches, :payload, :integer
  end
end
