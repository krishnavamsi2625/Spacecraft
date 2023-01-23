class SatellitesController < ApplicationController
    skip_before_action :verify_authenticity_token
  def index
    @satellites=Satellite.all
    render json:@satellites
  end
  def show
    begin
        @satellite=Satellite.find(params[:id])
        render json:@satellite
    rescue
        return render json: {error: "Satellite not found"},status: 400
        
    end
  end
  def new
    @satellite=LaunchVehicle.new
  end
  def create
    if !(LaunchVehicle.ids.to_a.any?)
        #redirect_to new_launch_vehicle_path,notice:"Create Launch vehicle to proceed" 
        return render json:{error: "Eneter launch vehicle first"}
    end
    if !(LaunchVehicle.pluck(:name).include?params[:satellite][:vehicle_name])
      #render :edit,notice:"Launch Vehicle not found",status: 400
      return render json:{error: "Launch vehicle not found"}
    end
    @article_id=LaunchVehicle.find_by(name:params[:satellite][:vehicle_name]).id
    @vehicle=LaunchVehicle.find(@article_id)
    @sum=@vehicle.satellites.sum(:weight)
    @sum||=0
    @sum+=params[:satellite][:weight]
    if(@sum>@vehicle.payload)
      return render json:{message:"Weight cannot be greater than #{@vehicle.payload-@sum+params[:satellite][:weight]}"}
    end
    @temp=param_validator
    @temp['launch_vehicle']=@vehicle
    @satellite=Satellite.create(@temp)
    if @satellite.save
      #redirect_to @vehicle,notice:"Created Sucessfully"
      render json:@satellite
    else 
      #render :new, status: :unprocessable_entity,alert: "Record not Created"
      return render json:{error:"Record not created"}
    end
  end
  def edit
    begin
      @satellite=Satellite.find(params[:id])
    rescue
      #redirect_to root_path,alert: exception.full_message
      return render json:{error:"Not found"}
    end
  end
  def update
    begin
      @satellite=Satellite.find(params[:id])
    rescue
      #redirect_to root_path,alert: "Cannot Update"
      return render json:{alert: "Cannot Find Record"}
    end
    if !(LaunchVehicle.pluck(:name).include?params[:satellite][:vehicle_name])
      return render json:{error: "Launch vehicle not found"},status: 400
    end
    @vehicle_id=LaunchVehicle.find_by(name:params[:satellite][:vehicle_name]).id
    @vehicle=LaunchVehicle.find(@vehicle_id)
    @sum=@vehicle.satellites.sum(:weight)
    @sum||=0
    @sum+=params[:satellite][:weight]
    if(@sum-@satellite.weight>@vehicle.payload)
      return render json:{message:"Weight cannot be greater than #{@vehicle.payload-@sum+params[:satellite][:weight]+@satellite.weight}"}
    end
    @temp=param_validator
    @temp['launch_vehicle']=@vehicle
    if @satellite.update(@temp)
      #redirect_to  root_path,notice: "Record Updated sucessfully"
      render json:{message:"Updated Sucessfully",record:@satellite}
    else
      #render :edit,status: :unprocessable_entity,alert:"Cant update" 
      return render json:{error:"Cant Update"}
    end
  end
  def destroy
    begin
      @satellite=Satellite.find(params[:id])
    rescue
      return render json:{alert:"Cannot be deleted"}
    end  
    if @satellite.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully"  
      render json:{message:"Deleted sucessfully"}
    else
      return render json:{error:"Cant Update"}
    end
  end
  private
  def param_validator
    params.require(:satellite).permit(:name,:weight,:owned_by,:launch_date)
  end
end
