module Oauth
  class Keycloak < Oauth::Base
    ACCESS_TOKEN_URL = 'https://accounts.organicity.eu/realms/organicity/protocol/openid-connect/token'
    USER_URL =         'https://accounts.organicity.eu/realms/organicity/account'

    def get_data

      puts "=== This function is not needed, we get user info with the JWT"

      response = @client.get(USER_URL, oauth_token: @the_token, v: 20140806)

      @data = JSON.parse(response.body)
      @uid = @data["id"]
      @data
    end

    def formatted_user_data
      {
        provider:       'keycloak',
        token:          @the_token,
        rtoken:         @refresh_token,
       # uid:            @data['id'],
       # first_name:     @data['firstName'],
       # last_name:      @data['lastName'],
       # email:          @data['contact']['email'],
      }
    end

  end
end


