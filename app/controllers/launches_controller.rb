class LaunchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def launch
    launched=[]
    notlaunched=[]
    begin
      vehicle = LaunchVehicle.find(params[:id])
    rescue 
      return render json: {error: "Vehicle Not found"}
    end
    spacecraft_ids=params[:spacecraft][:ids]
    spacecraft_ids.each{|id|
    if(Spacecraft.exists?(id:id))
      launch=Launch.create(launch_date:DateTime.now,launch_vehicle:vehicle)
      spacecraft=Spacecraft.find(id)
      spacecraft.launch=launch
      launched.append(id)
    else
      notlaunched.append(id)
    end
    }
    render json:{Launched:launched,NotLaunched:notlaunched}
  end

end
