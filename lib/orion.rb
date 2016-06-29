require 'net/http'
require 'json'

module Orion
  ORION_URL = "http://ec2-52-40-19-99.us-west-2.compute.amazonaws.com:1026/v2/entities"

  def request_entities(raw_params)
    url = "#{ORION_URL}"
    if raw_params
      params = map_params(raw_params)
      url.concat(params)
    end
    send_request url
  end

  def map_params(params)
    query_params = ""
    query_params.concat(to_limit(params))
    query_params.concat(to_offset(params))
    query_params.concat(to_type(params))

    return query_params
  end

  def to_type(params)
    return params[:type] ? "&type=#{params[:type]}" : ""
  end

  def to_limit(params)
    if params[:per] == 'all'
      return "?limit=1000"
    else
      return "?limit=#{params[:per].to_i}"
    end
  end

  def to_offset(params)
    if params[:page] == 'all'
      return ""
    else
      return "&offset=#{(params[:page].to_i - 1) * params[:per].to_i}"
    end
  end
end
