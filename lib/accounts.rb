require 'http'
require 'json'
require 'base64'

module Accounts
  ACCOUNTS_URL = "https://accounts.organicity.eu/realms/organicity/protocol/openid-connect/token"

  # This method should probably be private or something
  def get_token
    client =  HTTP[:authorization => "Basic #{encode_secrets}", :content_type => "application/x-www-form-urlencoded"]
    return client.post(ACCOUNTS_URL, :form => {grant_type: "client_credentials"}).as_json
  end

  private
    def encode_secrets
      return Base64.strict_encode64("#{ENV['ORGANICITY_ACCOUNTS_ID']}:#{ENV['ORGANICITY_ACCOUNTS_SECRET']}").chomp
    end
end
