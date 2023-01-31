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
        if (@vehicle.spacecrafts.count==0)
          render json:{vehcile:@vehicle}
        else
          render json:{vehicle:@vehicle,launches:@vehicle.spacecrafts}
        end
    rescue
        return render json:{error: "Vehicle not found"}
        
    end
  end
  def new
    @vehicle=LaunchVehicle.new
  end
  def create
    @vehicle=LaunchVehicle.create(valid_param)
    if @vehicle.id?
      render json:{vehicle:@vehicle,notice:"Created Sucessfully"}
    else 
      return render json:{error: "Record not Created"}
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
      return render json: { error: "Vehicle Not found"}
    end
    totalWeight=@vehicle.spacecrafts.sum(:weight)
    if(params[:launch_vehicle][:payload]<totalWeight)
      return render json:{error:"Cant reduce payload below#{totalWeight}"}
    end
    if @vehicle.update(valid_param)
      render json: { notice:"Updated sucessfully",vehicle:@vehicle}    
    else
      return render json:{error:"Cant update record"} 
    end
  end
  def destroy
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue 
      return render json: { error: "Vehicle Not Found",status: 404}    
    end
    if(@vehicle.spacecrafts.length!=0)
      return render json:{error:"Can't delete  vehcile due to dependent spacecrafts"}
    end
    if @vehicle.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully" 
      render json:{notice:"Deleted sucessfully"}
    else
      return render json:{error:"Cant Delete"}
    end
  end
  private
    def valid_param
      params.require(:launch_vehicle).permit(:name,:weight,:owned_by,:payload,:reusable)
    end
end
