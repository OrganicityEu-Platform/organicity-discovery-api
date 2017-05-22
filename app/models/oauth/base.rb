module Oauth
  require 'jwt'
  class Base

    attr_reader :provider, :data, :access_token, :uid

    def initialize params
      @provider = self.class.name.split('::').last.downcase
      prepare_params params
      puts "PARAMS - #{@params}"
      @client = HTTPClient.new
      @access_token = params[:access_token].presence || get_access_token
      puts "ACCESS TOKEN IS - #{@access_token}"

      if @access_token.present?
        token = JWT.decode @access_token, nil, false
        #puts token
        #puts token.first['email']
      else
        puts "== no access_token"
      end
      #get_data if @access_token.present?
    end

    def get_access_token
      response = @client.post(self.class::ACCESS_TOKEN_URL, @params)
      puts "ACCESS TOKEN RESPONSE - #{response.body}"
      JSON.parse(response.body)["access_token"]
    end

    def prepare_params params
      @params = {
        code:          params[:code],
        redirect_uri:  params[:redirectUri],
        client_id:     ENV['KEYCLOAK_CLIENT_ID'],
        client_secret: ENV['KEYCLOAK_CLIENT_SECRET'],
        grant_type:    'authorization_code'
      }
    end

    def authorized?
      @access_token.present?
    end

  end

end
