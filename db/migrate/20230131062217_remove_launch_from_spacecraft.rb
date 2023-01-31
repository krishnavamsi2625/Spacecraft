class RemoveLaunchFromSpacecraft < ActiveRecord::Migration[7.0]
  def change
    remove_reference :launches, :spacecraft, index: true
  end
end
