class LaunchVehicle < ApplicationRecord
    after_find :default_value
    has_many :spacecrafts
    validates :name ,presence:true
    validates :weight,presence:true,numericality:{only_integer: true,greater_than_or_equal_to:10,message: "Sould be greater than 9"}
    def default_value
        self.payload||=0
    end
end
