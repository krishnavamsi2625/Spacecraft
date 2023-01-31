class LaunchVehicle < ApplicationRecord
    after_find :default_value
    has_many :launches
    has_many :spacecrafts,through: :launches
    validates :name ,presence:true
    validates :weight,presence:true,numericality:{only_integer: true,greater_than_or_equal_to:10,message: "Sould be greater than 9"}
    def default_value
        self.payload||=0
        self.reusable=false if(self.reusable==nil)
    end
end
