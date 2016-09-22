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
    return setup_dictionary_client.get("#{DICTIONARY_URL}/#{endpoint}").as_json
  end

end
