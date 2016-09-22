require 'http'
require 'json'
require 'base64'

module Dictionary
  DICTIONARY_URL = 'http://dev.server.organicity.eu:8080/v1/dictionary'


  def unregistered_asset_types
    endpoint = '/unregisteredassettype'
    return get_token

    # client =  HTTP[:authorization => "Basic #{encode_secrets}", :content_type => "application/x-www-form-urlencoded"]
    # return client.post(ACCOUNTS_URL, :form => {grant_type: "client_credentials"}).as_json

  end



    # get /dictionary/assettypes
    #     Finds all the asset types
    #
    # get /dictionary/assettypes/{name}
    #     Find asset type by name
    #
    # get /dictionary/attributetypes
    #     Finds all the attribute types
    #
    # get /dictionary/attributetypes/{name}
    #     Find attribute type by name
    #
    # get /dictionary/units
    #     Finds all the units
    #
    # get /dictionary/units/{name}
    #     Find unit by name
    #
    # get /dictionary/datatypes
    #     Finds all the data types
    #
    # get /dictionary/datatypes/{name}
    #     Find data type by name
    #
    # get /dictionary/tools
    #     Finds all the tools
    #
    # get /dictionary/applicationtypes
    #     Finds all the applications types

end
