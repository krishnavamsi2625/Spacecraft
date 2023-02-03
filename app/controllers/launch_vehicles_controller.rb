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
        launches={}
        @vehicle.launches.to_a.each do |launch|
          spacecrafts=launch.spacecrafts.all
          launches[launch.launch_date]=spacecrafts
        end 
        render json:{Vehcile:@vehicle,launches:launches}
    rescue 
        return render json: {error: "Vehicle not found"},status: 400
        
    end
  end
  def new
    @vehicle=LaunchVehicle.new
  end
  def create
    @vehicle = LaunchVehicle.create(valid_param)
    if @vehicle.save
      render json:{vehicle:@vehicle, message: "Created Sucessfully"}
    else 
      return render json:{error: "Record not Created"}
    end
  end
  def edit 
    begin
      @vehicle = LaunchVehicle.find(params[:id])
    rescue
      return render json: {error: "Vehicle Not found"}

    end
  end
  def update 
    begin
      @vehicle = LaunchVehicle.find(params[:id])
    rescue 
      return render json: {error: "Vehicle Not found"}
    end
    @vehicle.launches.each{ |launch|
      totalWeight = launch.spacecrafts.sum(:weight)
      if(params[:launch_vehicle][:payload]<totalWeight)
        return render json:{error: "Cant reduce payload below#{@totalWeight}"}
      end
    }
    if @vehicle.update(valid_param)
      render json: { message: "Updated sucessfully", record:@vehicle}    
    else
      return render json:{error: "Cant update record"} 
    end
  end
  def destroy
    begin
      @vehicle = LaunchVehicle.find(params[:id])
    rescue 
      return render json: {error: "Vehicle Not Found"}    
    end
    if(@vehicle.spacecrafts.count!=0)
      return render json:{error: "Can't delete  vehcile due to dependent spacecrafts"}
    end
    LaunchVehicle.find(1).launches.destroy_all
    if @vehicle.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully" 
      render json:{message: "Deleted sucessfully"}
    else
      return render json:{error: "Cant Delete"}
    end
  end
  private
  def valid_param
    params.require(:launch_vehicle).permit(:name,:weight,:owned_by,:payload,:reusable)
  end
end
