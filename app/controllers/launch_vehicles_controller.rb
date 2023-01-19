class LaunchVehiclesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @vehicles=LaunchVehicle.all
    render json:@vehicles
  end
  def show
    begin
        @vehicle=LaunchVehicle.find(params[:id])
        render json:@vehicle
    rescue
        render json: {error: "Id not found"},status: 400
        
    end
  end
  def new
    @vehicle=LaunchVehicle.new
  end
  def create
    @vehicle=LaunchVehicle.create(param_validator)
    if @vehicle.save
      redirect_to @vehicle,notice:"Created Sucessfully"
    else 
      render :new, status: :unprocessable_entity,alert: "Record not Create"
    end
  end
  def edit 
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue =>exception
      redirect_to root_path,alert: exception.full_message
    end
  end
  def update 
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue =>exception
      redirect_to root_path,alert: exception.full_message
    end
    if @vehicle.update(param_validator)
      redirect_to  root_path,notice: "Record Updated sucessfully"
    else
      render :edit,status: :unprocessable_entity,notice:"Cant update" 
    end
  end
  def destroy
    begin
      @vehicle=LaunchVehicle.find(params[:id])
    rescue =>exception
      redirect_to root_path,alert: exception.full_message
    end
    @vehicle.destroy
    redirect_to root_path status: :see_other,notice: "Deleted sucessfully"  
  end
  private
  def param_validator
    params.require(:launch_vehicle).permit(:name,:weight,:owned_by)
  end
end
