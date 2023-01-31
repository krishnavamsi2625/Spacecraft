class AddSpacecraftsToLaunch < ActiveRecord::Migration[7.0]
  def change
    add_reference :spacecrafts, :launch, index: true
  end
end
