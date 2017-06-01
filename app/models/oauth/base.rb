module Oauth
  require 'jwt'
  class Base

    attr_reader :provider, :data, :access_token, :uid

    def initialize params
      @provider = self.class.name.split('::').last.downcase
      prepare_params params

      @client = HTTPClient.new

      # If we have the refresh_token, this is a refresh request
      if params.has_key?(:refresh_token)
        @params[:grant_type] = 'refresh_token'
        @params[:refresh_token] = params['refresh_token']
        # TODO: Is this needed? When do we have params[:access_token] ?
        @the_token = params[:access_token].presence || get_tokens('refresh')
      else
        @the_token = params[:access_token].presence || get_tokens('access')
      end

      puts "@PARAMS - #{@params}"
      puts "THE TOKEN IS - #{@the_token}"

      if @the_token.present?
        token = JWT.decode @the_token, nil, false
      else
        puts "@the_token not found"
      end
    end

    def get_tokens(tokentype)
      puts "==== get_tokentype: #{tokentype}"
      response = @client.post(self.class::ACCESS_TOKEN_URL, @params)
      puts "TOKEN response.body - #{response.body}"
      if tokentype == 'refresh'
        @extra = "no need, the main token: is the refresh_token"
        JSON.parse(response.body)["refresh_token"]
      else
        @extra = JSON.parse(response.body)["refresh_token"]
        JSON.parse(response.body)["access_token"]
      end
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
      @the_token.present?
    end

  end

end
