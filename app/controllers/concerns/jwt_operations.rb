require 'jwt'

module JwtOperations
  extend ActiveSupport::Concern

  # In the future check https://github.com/nsarno/knock

  def decode_token(token)
    return JWT.decode token, nil, false
  end

  def token(token)
    token ? decode_token(token) : " "
  end

  def token_session(token)
    token ? decode_token(token).first["client_session"] : 'no_session'
  end
end

