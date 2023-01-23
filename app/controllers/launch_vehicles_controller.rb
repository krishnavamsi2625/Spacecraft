class LaunchVehiclesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @vehicles=LaunchVehicle.all
    @spacecrafts=Spacecraft.all
    render json:@vehicles
  end
  def show
    begin
        @vehicle=LaunchVehicle.find(params[:id])
        render json:@vehicle
    rescue
        return render json: {error: "Vehicle not found"},status: 400
        
    end
  end
  def new
    @vehicle=LaunchVehicle.new
  end
  def create
    @vehicle=LaunchVehicle.create(param_validator)
    if @vehicle.save
      render json:{vehicle:@vehicle,notice:"Created Sucessfully"}
    else 
      return render json:{alert: "Record not Created"}
    end
  end
  def edit 
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue
      return render json: { error: "Vehicle Not found"}

    end
  end
  def update 
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue 
      return render json: { alert: "Vehicle Not found",status: 400}
    end
    @totalWeight=@vehicle.spacecrafts.sum(:weight)
    if(params[:launch_vehicle][:payload]<@totalWeight)
      return render json:{error:"Cant reduce payload below#{@totalWeight}"}
    end
    if @vehicle.update(param_validator)
      render json: { message:"Updated sucessfully",record:@vehicle}    
    else
      return render json:{error:"Cant update record"} 
    end
  end
  def destroy
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue 
      return render json: { error: "Vehicle Not Found",status: 400}    
    end
    if(@vehicle.spacecrafts.length!=0)
      return render json:{Error:"Can't delete  vehcile due to dependent spacecrafts"}
    end
    if @vehicle.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully" 
      render json:{message:"Deleted sucessfully"}
    else
      return render json:{error:"Cant Delete"}
    end
  end
  private
  def param_validator
    params.require(:launch_vehicle).permit(:name,:weight,:owned_by,:payload)
  end
end
