class LaunchVehiclesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def show
    launch_vehicle_id=params[:id]
    begin
      doc=$client.get(index:"launch_vehicles",id:launch_vehicle_id)
      render json:{document:[doc]}
    rescue 
      render json:{error:"Vehicle not found"}
    end
  end
  def mapping
      launch_mapping={
          "mappings": {
            "properties": {
              "name": {
                "type": "text",
                "fields": {
                  "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                  }
                }
              },
              "payload_capacity": {
                "type": "integer"
              },
              "cordinator": {
                "type": "text"
              },
              "launch_date": {
                "type": "date"
              },
              "reusable": {
                "type": "boolean"
              }
            }
          }
      }
      begin
        $client.indices.create(index:"launch_vehicles",body:launch_mapping)
        render json:{message:"Created mappings sucessfully"}
      rescue 
        render json:{error:"Can't  create  mappings"}
      end
  end
  def bulk
    index=count
    body=[
      {index:{_index:'launch_vehicles',_id:index+1}},
      { "name": "Test 1", "cordinator": "abc", "payload_capacity":40, "launch_date": ["2023-02-05","2023-02-07"], "reusable": "true"},
      {index:{_index:'launch_vehicles',_id:index+2}},
      { "name": "Test 2", "cordinator": "xyz", "payload_capacity":50, "launch_date": "2023-02-06", "reusable": "false"}
    ]
    begin
      $client.bulk(body:body)
      render json:{message:"Bulk Updated the index sucessfully"}
    rescue 
      render json:{error:"Can't bulk update  index"}
    end
  end
  def new
    body=valid_param
    begin
      doc=$client.index(index:'launch_vehicles',body:body,id:(count+1))
      render json:{message:"Created Doc sucessfully",document:[doc]}
    rescue
      render json:{error:"Cant Create Doc"}
    end
  end
  def update
    body={}
    body['doc']=valid_param
    begin
      doc=$client.update(index:'launch_vehicles',body:body,id:params[:id])
      render json:{message:"Updated Doc sucessfully",document:[doc]}
    rescue
      render json:{error:"Cant Update Doc"}
    end
  end
  def destroy_index
      begin
        $client.indices.delete(index:"launch_vehicles")
        render json:{message:"Deleted the index sucessfully"}
      rescue 
        render json:{error:"Can't Delete Index"}
      end
  end
  def delete
    begin
      $client.delete(index:'launch_vehicles',id:params[:id])
      render json:{message:"Deleted Sucessfully"}
    rescue
      render json:{error:"Cant delete"}
    end

  end
  private
    def count
      $client.count(index:'launch_vehicles')['count']
    end
    def valid_param
      params.require(:launch_vehicle).permit(:name,:payload_capacity,:cordinator,:launch_date,:reusable)
    end
end
