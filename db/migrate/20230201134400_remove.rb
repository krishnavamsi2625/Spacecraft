class Remove < ActiveRecord::Migration[7.0]
  def change
    remove_column :launches, :payload
  end
end
