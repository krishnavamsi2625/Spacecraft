class SpacecraftsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @spacecrafts=Spacecraft.all
    render json:@spacecrafts
  end
  def show
    begin
        @spacecraft=Spacecraft.find(params[:id])
        render json:@spacecraft
    rescue
        return render json: {error: "Spacecraft not found"},status: 400
        
    end
  end
  def new
    @spacecraft=Spacecraft.new
  end
  def create
    if !(LaunchVehicle.ids.to_a.any?)
        #redirect_to new_launch_vehicle_path,notice:"Create Launch vehicle to proceed" 
        return render json:{error: "Create Launch vehicle to proceed"}
    end
    if !(LaunchVehicle.pluck(:name).include?params[:spacecraft][:vehicle_name])
      #render :edit,notice:"Launch Vehicle not found",status: 400
      return render json:{error: "Launch vehicle not found"}
    end
    @vehicle_id=LaunchVehicle.find_by(name:params[:spacecraft][:vehicle_name]).id
    @vehicle=LaunchVehicle.find(@vehicle_id)
    @sum=@vehicle.spacecrafts.sum(:weight)
    if(@sum==@vehicle.payload)
      return render json:{alert:"Vehicle full"}
    end
    @sum||=0
    @sum+=params[:spacecraft][:weight]
    if(@sum>@vehicle.payload)
      return render json:{message:"Weight cannot be greater than #{@vehicle.payload-@sum+params[:spacecraft][:weight]}"}
    end
    @temp=param_validator
    @temp['launch_vehicle']=@vehicle
    @spacecraft=Spacecraft.create(@temp)
    if @spacecraft.save
      #redirect_to @vehicle,notice:"Created Sucessfully"
      render json:{Spacecraft:@spacecraft,notice:"Created Sucessfully"}
    else 
      #render :new, status: :unprocessable_entity,alert: "Record not Created"
      return render json:{error:"Record not created"}
    end
  end
  def edit
    begin
      @spacecraft=Spacecraft.find(params[:id])
    rescue
      #redirect_to root_path,alert: exception.full_message
      return render json:{error:" Spacecraft Not found"}
    end
  end
  def update
    begin
      @spacecraft=Spacecraft.find(params[:id])
    rescue
      #redirect_to root_path,alert: "Cannot Update"
      return render json:{alert: "Cannot Find Record"}
    end
    if !(LaunchVehicle.pluck(:name).include?params[:spacecraft][:vehicle_name])
      return render json:{error: "Launch vehicle not found"},status: 400
    end
    @vehicle_id=LaunchVehicle.find_by(name:params[:spacecraft][:vehicle_name]).id
    @vehicle=LaunchVehicle.find(@vehicle_id)
    @sum=@vehicle.spacecrafts.sum(:weight)
    @sum||=0
    @sum+=params[:spacecraft][:weight]
    if(@sum-@spacecraft.weight>@vehicle.payload)
      return render json:{message:"Weight cannot be greater than #{@vehicle.payload-@sum+params[:spacecraft][:weight]+@spacecraft.weight}"}
    end
    @temp=param_validator
    @temp['launch_vehicle']=@vehicle
    if @spacecraft.update(@temp)
      #redirect_to  root_path,notice: "Record Updated sucessfully"
      render json:{message:"Updated Sucessfully",record:@spacecraft}
    else
      #render :edit,status: :unprocessable_entity,alert:"Cant update" 
      return render json:{error:"Cant Update Record"}
    end
  end
  def destroy
    begin
      @spacecraft=Spacecraft.find(params[:id])
    rescue
      return render json:{alert:"Spacecraft Not Found"}
    end  
    if @spacecraft.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully"  
      render json:{message:"Deleted sucessfully"}
    else
      return render json:{error:"Cant Delete"}
    end
  end
  private
  def param_validator
    params.require(:spacecraft).permit(:name,:weight,:owned_by,:launch_date)
  end
end
