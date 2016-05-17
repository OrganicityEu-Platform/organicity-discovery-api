require 'net/http'
require 'json'

module Orion
  ORION_URL = "http://ec2-54-68-181-32.us-west-2.compute.amazonaws.com:1026/v2/entities"

  def request_entities
    send_request "#{ORION_URL}"
  end
end
