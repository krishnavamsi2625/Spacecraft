class SpacecraftsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @spacecrafts = Spacecraft.all
    render json:@spacecrafts
  end
  def show
    begin
        @spacecraft = Spacecraft.find(params[:id])
        render json:{Spacecraft:@spacecraft,LaunchVehicle:@spacecraft.launch_vehicle}
        #render json:@spacecraft
    rescue
        return render json: {error: "Spacecraft not found"}
        
    end
  end
  def new
    @spacecraft = Spacecraft.new
  end
  def create
    @spacecraft = Spacecraft.create(valid_param)
    if @spacecraft.id?
      #redirect_to @vehicle,notice:"Created Sucessfully"
      render json:{Spacecraft:@spacecraft, notice:"Created Sucessfully"}
    else 
      #render :new, status: :unprocessable_entity,alert: "Record not Created"
      return render json:{error: "Record not created"}
    end
  end
  def edit
    begin
      @spacecraft=Spacecraft.find(params[:id])
    rescue
      #redirect_to root_path,alert: exception.full_message
      return render json:{error: "Spacecraft Not found"}
    end
  end
  def update
    begin
      @spacecraft=Spacecraft.find(params[:id])
    rescue
      #redirect_to root_path,alert: "Cannot Update"
      return render json:{error: "Cannot Find Record"}
    end
    if @spacecraft.update(valid_param)
      #redirect_to  root_path,notice: "Record Updated sucessfully"
      render json:{message: "Updated Sucessfully", record:@spacecraft}
    else
      #render :edit,status: :unprocessable_entity,alert:"Cant update" 
      render json:{error: "Cant Update Record"}
    end
  end
  def destroy
    begin
      @spacecraft=Spacecraft.find(params[:id])
    rescue
      return render json:{error:"Spacecraft Not Found"}
    end  
    if @spacecraft.destroy
      #redirect_to root_path status: :see_other,notice: "Deleted sucessfully"  
      render json:{message: "Deleted sucessfully"}
    else
      return render json:{error: "Can't Delete"}
    end
  end
  private
  def valid_param
    params.require(:spacecraft).permit(:name,:weight,:owned_by,:expected_launch_date)
  end
end
