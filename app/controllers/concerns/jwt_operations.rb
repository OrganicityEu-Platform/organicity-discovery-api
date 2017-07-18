require 'jwt'

module JwtOperations
  extend ActiveSupport::Concern

  # In the future check https://github.com/nsarno/knock

  def decode_token(token)
    # TODO: JWT::DecodeError (Not enough or too many segments)
    # app/controllers/concerns/jwt_operations.rb:17:in `token_session'
    # app/controllers/v0/assets_controller.rb:71:in `geo_count'
    logger.warn token
    return JWT.decode token, nil, false
  end

  def token(token)
    token ? decode_token(token) : " "
  end

  def token_session(token)
    token ? decode_token(token).first["client_session"] : 'no_session'
  end
end

