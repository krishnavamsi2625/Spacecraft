class SpacecraftsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def show
    spacecraft_id=params[:id]
    begin
      doc=$client.get(index:"spacecrafts",id:spacecraft_id)
      render json:{document:[doc]}
    rescue 
      render json:{error:"Spacecraft not found"}
    end
  end
  def mapping
      spacecraft_mapping={
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
              "weight": {
                "type": "integer"
              },
              "launch_date": {
                "type": "date"
              },
              "launch_vehicle_id": {
                "type": "keyword"
              }
            }
          }
        }
      begin
        $client.indices.create(index:"spacecrafts",body:spacecraft_mapping)
        render json:{message:"Created mappings sucessfully"}
      rescue 
        render json:{error:"Can't  create  mappings"}
      end
  end
  def bulk
    index=count
    body=[
      {index:{_index:'spacecrafts',_id:index+1}},
      { "name": "Chadrayan advanced", "weight": 20, "launch_date": "2023-02-05", "launch_vehicle_id": 1 },
      {index:{_index:'spacecrafts',_id:index+2}},
      { "name": "Chadrayan basic", "weight": 30, "launch_date": "2023-02-06", "launch_vehicle_id": 2 },
      {index:{_index:'spacecrafts',_id:index+3}},
      { "name": "Test spacecraft", "weight": 20, "launch_date": "2023-02-07", "launch_vehicle_id": 1 }
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
      doc=$client.index(index:'spacecrafts',body:body,id:(count+1))
      render json:{message:"Created Doc sucessfully",document:[doc]}
    rescue
      render json:{error:"Cant Create Doc"}
    end
  end
  def update
    body={}
    body['doc']=valid_param
    begin
      doc=$client.update(index:'spacecrafts',body:body,id:params[:id])
      render json:{message:"Updated Doc sucessfully",document:[doc]}
    rescue
      render json:{error:"Cant Update Doc"}
    end
  end
  def destroy_index
      begin
        $client.indices.delete(index:"spacecrafts")
        render json:{message:"Deleted the index sucessfully"}
      rescue 
        render json:{error:"Can't Delete Index"}
      end
  end
  def delete
    begin
      $client.delete(index:'spacecrafts',id:params[:id])
      render json:{message:"Deleted Sucessfully"}
    rescue
      render json:{error:"Cant delete"}
    end

  end
  private
    def count
      $client.count(index:'spacecrafts')['count']
    end
    def valid_param
      params.require(:spacecraft).permit(:name,:weight,:launch_date,:launch_vehicle_id)
    end
end
