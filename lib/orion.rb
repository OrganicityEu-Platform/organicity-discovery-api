require 'net/http'
require 'json'

module Orion
  ORION_URL = "http://ec2-52-40-19-99.us-west-2.compute.amazonaws.com:1026/v2/entities"

  def request_entities(params)
    print "orion: #{params}\n"
    send_request "#{ORION_URL}?#{map_params(params)}"
  end

  def map_params(params)
    query_params = ""
    query_params.concat(limit(params)) if params[:per]

    query_params
  end

  def limit(params)
    return "limit=#{params[:page].to_i * params[:per].to_i}"
  end
end
