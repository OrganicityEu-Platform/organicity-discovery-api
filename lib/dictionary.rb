require 'http'
require 'json'
require 'base64'

module Dictionary
  DICTIONARY_URL = 'http://dev.server.organicity.eu:8080/v1/dictionary'

  def setup_dictionary_client
    token_request = get_token["body"]
    token = JSON.parse(token_request[0])["access_token"]
    client =  HTTP[:authorization => "#{token}", :accept => "application/json"]
  end

  def query_dictionary(endpoint)
    call = RestCall.find(params: {}, endpoint: endpoint).sort(by: :created_at)
    if call.empty? or ( Time.now > Time.parse(call.last.created_at) + 30.seconds )
      @response = setup_dictionary_client.get("#{DICTIONARY_URL}/#{endpoint}").body.as_json
      @cached_call = RestCall.create(params: {}, endpoint: endpoint, created_at: Time.now, response: @response)
    else
      @respone = call.response
    end
    return @response
  end

end
