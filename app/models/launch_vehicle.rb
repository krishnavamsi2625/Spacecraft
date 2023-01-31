class LaunchVehicle < ApplicationRecord
    after_find :default_value
    has_many :launches
    has_many :spacecrafts,through: :launches
    def default_value
        self.payload||=0
        self.reusable=false if(self.reusable==nil)
    end
end
