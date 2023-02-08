class QueriesController < ApplicationController
  def spacecrafts_name
    name=params[:spacecrafts][:name]
    query={
      "_source": ["name","weight","launch_date"],
      "query": {
        "match": {
          "name": name
        }
      }
    }
    response=spacecrafts_search(query)
    render json:{search:[query],reponse:[response]}
  end
  def launch_vehicles_range
    from=params[:launch_vehicles][:from]
    to=params[:launch_vehicles][:to]
    if(params[:id]=='1')
      query={
        "_source": [
          "name",
          "launch_date"
        ],
        "query": {
          "range": {
            "launch_date": {
              "gte": from,
              "lte": to,
              "format": "dd/MM/yyyy||yyyy"
            }
          }
        }
      }
    else 
      query={
        "_source": [
          "name",
          "launch_date"
        ],
        "query": {
          "range": {
            "launch_date": {
              "gt": from,
              "lt": to,
              "format": "dd/MM/yyyy||yyyy"
            }
          }
        }
      }
    end
    response=launch_vehicles_search(query)
    render json:{search:[query],reponse:[response]}
  end
  def launch_vehicles_spacecrafts
    launch_vehicles_ids=get_launch_vehicles_ids
    query={
      "size": 0,
      "aggs": {
        "spacecraft_launch_vehicles": {
          "terms": {
            "field": "name.keyword",
            "size": 10
          }
        }
      },
      "query": {
        "terms": {
          "_id":launch_vehicles_ids
        }
      }
    }
    response=launch_vehicles_search(query)
    render json:{search:[query],reponse:[response]}
  end
  def launch_vehicles_spacecrafts_cordinator
    launch_vehicles_ids=get_launch_vehicles_ids
    cordinator=params[:launch_vehicles][:cordinator]
    query={
      "size": 0,
      "aggs": {
        "corodinator_filter": {
          "filter": {
            "term": {
              "cordinator":cordinator
            }
          },
          "aggs": {
            "spacecraft_launch_vehicle": {
              "terms": {
                "field": "name.keyword",
                "size": 10
              }
            }
          }
        }
      },
      "query": {
        "terms": {
          "_id":launch_vehicles_ids
        }
      }
    }
    response=launch_vehicles_search(query)
    render json:{search:[query],reponse:[response]}
  end
  def launch_vehicles_top_hits
    launch_vehicles_ids=get_launch_vehicles_ids
    cordinator=params[:launch_vehicles][:cordinator]
    query={
      "size": 0,
      "aggs": {
        "cordinator_filter": {
          "filter": {
            "term": {
              "cordinator":cordinator
            }
          },
          "aggs": {
            "spacecraft_launch_vehicle": {
              "terms": {
                "field": "name.keyword",
                "size": 10
              },
              "aggs": {
                "top_hits": {
                  "top_hits": {
                    "size": 10,
                    "_source": {
                      "includes": [
                        "name",
                        "cordinator"
                      ]
                    }
                  }
                }
              }
            }
          }
        }
      },
      "query": {
        "terms": {
          "_id":launch_vehicles_ids
        }
      }
    }
    response=launch_vehicles_search(query)
    render json:{search:[query],reponse:[response]}
  end
  def launch_vehicles_bool
    from=params[:launch_vehicles][:payload_from]
    to=params[:launch_vehicles][:payload_to]
    reusable=params[:launch_vehicles][:reusable]
    cordinator=params[:launch_vehicles][:cordinator]
    query={
      "query": {
        "bool": {
          "must": [
            {
              "range": {
                "payload_capacity": {
                  "gte": from,
                  "lte": to
                }
              }
            }
          ],
          "should": [
            {
              "match": {
                "cordinator": cordinator
              }
            }
          ],
          "must_not": [
            {
              "match": {
                "reusable": reusable
              }
            }
          ]
        }
      }
    }
    response=launch_vehicles_search(query)
    render json:{search:[query],reponse:[response]}
  end
  private
      def launch_vehicles_search(query)
        begin 
          return $client.search(index:'launch_vehicles',body:query)
        rescue
          return "Query cannot be executed"
        end
      end
      def spacecrafts_search(query)
        begin 
          return $client.search(index:'spacecrafts',body:query)
        rescue 
          return "Query cannot be executed"
        end
      end
      def get_launch_vehicles_ids
        launch_vehicles_ids=[]
        params[:launch_vehicles][:spacecraft_ids].each do |spacecraft_id|
          launch_vehicles_ids.append($client.get(index:"spacecrafts",id:spacecraft_id)["_source"]["launch_vehicle_id"])
        end
        return launch_vehicles_ids
      end        
end


