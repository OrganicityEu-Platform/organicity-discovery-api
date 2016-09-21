require 'http'
require 'json'
require 'base64'

module Accounts
  ACCOUNTS_URL = "https://accounts.organicity.eu/realms/organicity/protocol/openid-connect/token"

  # This method should probably be private or something
  def get_token
    return HTTP.auth("Basic #{encode_secrets}").post(ACCOUNTS_URL)
  end

  private
    def encode_secrets
      return Base64.encode64("#{ENV['ORGANICITY_ACCOUNTS_ID']}:#{ENV['ORGANICITY_ACCOUNTS_SECRET']}")
    end
end
