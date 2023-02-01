class LaunchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def launch
    launched=[]
    notlaunched=[]
    notfound=[]
    begin
      vehicle = LaunchVehicle.find(params[:id])
    rescue 
      return render json: {error: "Vehicle Not found"}
    end
    spacecraft_ids=params[:spacecrafts][:ids]
    launch=Launch.create(launch_date: DateTime.now, launch_vehicle: vehicle, payload: 0)
    spacecraft_ids.each do |id|
      if(Spacecraft.exists?(id:id))
        spacecraft=Spacecraft.find(id)
        spacecraft.launch=launch
        if spacecraft.save
          launched.append(id)
        else
          notlaunched.append(id)
        end
        
      else
        notfound.append(id)
      end
    end
    render json:{Launched:launched,NotLaunched:notlaunched,NotFound:notfound}
  end

end
