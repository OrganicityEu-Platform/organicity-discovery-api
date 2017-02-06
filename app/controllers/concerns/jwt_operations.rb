require 'jwt'

module JwtOperations
  extend ActiveSupport::Concern

  # In the future check https://github.com/nsarno/knock

  def decode_token(token)
    return JWT.decode token, nil, false
  end

  def token(token)
    token ? decoded_token(token) : " "
  end

  def token_session(token)
    token ? decoded_token(token).client_session : 'no_session'
  end
end

