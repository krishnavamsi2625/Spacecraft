class LaunchVehicle < ApplicationRecord
    has_many :launch_vehicles
    validates :name ,presence:true
    validates :weight,presence:true,numericality:{only_integer: true,greater_than_or_equal_to:10,message: "Sould be greater than 9"}
end
