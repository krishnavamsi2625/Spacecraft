class LaunchVehiclesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @vehicles=LaunchVehicle.all
    @satellites=Satellite.all
    render json:@vehicles
  end
  def show
    begin
        @vehicle=LaunchVehicle.find(params[:id])
        render json:@vehicle
    rescue
        return render json: {error: "Id not found"},status: 400
        
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
      return render :new, status: :unprocessable_entity,alert: "Record not Create"
    end
  end
  def edit 
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue
      return render json: { alert: "Vehicle Not found",status: 400}

    end
  end
  def update 
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue 
      return render json: { alert: "Vehicle Not found",status: 400}
    end
    if @vehicle.update(param_validator)
      render json: { message:"Updated sucressfully"}    
    else
      return render json:{status: :unprocessable_entity,notice:"Cant update"} 
    end
  end
  def destroy
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue 
      return render json: { alert: "Vehicle Not found",status: 400}    
    end
    if @vehicle.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully" 
      render json:{message:"Deleted sucessfully"}
    else
      return render json:{error:"Cant Update"}
    end
  end
  private
  def param_validator
    params.require(:launch_vehicle).permit(:name,:weight,:owned_by)
  end
end
