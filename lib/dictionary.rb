require 'http'
require 'json'
require 'base64'

module Dictionary
  DICTIONARY_URL = 'https://sitemanager.organicity.eu/v1/dictionary'

  def setup_dictionary_client
    token_request = get_token["body"]
    token = JSON.parse(token_request[0])["access_token"]
    client =  HTTP[:authorization => "#{token}", :accept => "application/json"]
  end

  def query_dictionary(endpoint)
    return JSON.parse(setup_dictionary_client.get("#{DICTIONARY_URL}/#{endpoint}").body)
  end

end
