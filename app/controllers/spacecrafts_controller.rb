class SpacecraftsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @spacecrafts=Spacecraft.all
    render json:@spacecrafts
  end
  def show
    begin
        @spacecraft=Spacecraft.find(params[:id])
        render json:{spacecraft:@spacecraft,vehicle:@spacecraft.launch_vehicle}
    rescue
        return render json: {error: "Spacecraft not found"}
        
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
      return render json:{error: "Launch vehicle not found",status:404}
    end
    @vehicle_id=LaunchVehicle.find_by(name:params[:spacecraft][:vehicle_name]).id
    @vehicle=LaunchVehicle.find(@vehicle_id)
    if(!@vehicle.reusable&&@vehicle.spacecrafts.count==1)
      return render json:{error:"Launch Vehicle Non-reusable"}
    end
    date=params[:spacecraft][:launch_date]
    if(date==nil||date==""||date==" ")
      save_attribute=valid_param
      @spacecraft=Spacecraft.create(save_attribute)
      if @spacecraft.id?
        #redirect_to @vehicle,notice:"Created Sucessfully"
        return render json:{spacecraft:@spacecraft,notice:"Created Sucessfully"}
      else 
        #render :new, status: :unprocessable_entity,alert: "Record not Created"
        return render json:{error:"Record not created"}
      end
    end
    if(Launch.exists?(launch_date:date))
      return render json:{error:"Launch Vehicle Already in Use!! "}
    end
    sum=@vehicle.spacecrafts.sum(:weight)
    if(sum==@vehicle.payload)
      return render json:{error:"Vehicle full"}
    end
    sum||=0
    sum+=params[:spacecraft][:weight]
    if(sum>@vehicle.payload)
      return render json:{message:"Weight cannot be greater than #{@vehicle.payload-sum+params[:spacecraft][:weight]}"}
    end
    save_attribute=valid_param
    @spacecraft=Spacecraft.create(save_attribute)
    if @spacecraft.id?
      #redirect_to @vehicle,notice:"Created Sucessfully"
      Launch.create(launch_date:date,launch_vehicle:@vehicle,spacecraft:@spacecraft)
      render json:{spacecraft:@spacecraft,notice:"Created Sucessfully"}
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
      return render json:{error: "Cannot Find Record"}
    end
    if !(LaunchVehicle.pluck(:name).include?params[:spacecraft][:vehicle_name])
      return render json:{error: "Launch vehicle not found",status:404}
    end
    @vehicle_id=LaunchVehicle.find_by(name:params[:spacecraft][:vehicle_name]).id
    @vehicle=LaunchVehicle.find(@vehicle_id)
    date=params[:spacecraft][:launch_date]
    if(!@vehicle.reusable&&@vehicle.spacecrafts.count==1&&@vehicle.spacecrafts.ids.exclude?(@spacecraft.id))
      return render json:{error:"Launch Vehicle Non-reusable"}
    end
    if(Launch.exists?(launch_date:date)&& date.to_date!=@spacecraft.launch_date)
      return render json:{error:"Launch Vehicle Already in Use!! "}
    end
    if(@spacecraft.launch_date!=nil)
      Launch.destroy_by(launch_date:@spacecraft.launch_date)
    end
    if(date==nil||date==""||date==" ")
      save_attribute=valid_param
      byebug
      if @spacecraft.update
        #redirect_to @vehicle,notice:"Created Sucessfully"
        return render json:{spacecraft:@spacecraft,notice:"Updated Sucessfully"}
      else 
        #render :new, status: :unprocessable_entity,alert: "Record not Created"
        return render json:{error:"Record not updated"}
      end
    end
    sum=@vehicle.spacecrafts.sum(:weight)
    sum+=params[:spacecraft][:weight]
    if(sum-@spacecraft.weight>@vehicle.payload)
      return render json:{message:"Weight cannot be greater than #{@vehicle.payload-sum+params[:spacecraft][:weight]+@spacecraft.weight}"}
    end
    save_attribute=valid_param
    if @spacecraft.update(save_attribute)
      #redirect_to  root_path,notice: "Record Updated sucessfully"
      Launch.create(launch_date:date,launch_vehicle:@vehicle,spacecraft:@spacecraft)
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
      return render json:{error:"Spacecraft Not Found",status:404}
    end
    date=@spacecraft.launch_date
    if(date!=nil)
      Launch.destroy_by(launch_date:date)
    end
      if @spacecraft.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully"  
      render json:{message:"Deleted sucessfully"}
    else
      return render json:{error:"Cant Delete"}
    end
  end
  private
  def valid_param
    params.require(:spacecraft).permit(:name,:weight,:owned_by,:launch_date)
  end
end
