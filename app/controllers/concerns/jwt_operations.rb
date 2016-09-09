require 'jwt'

module JwtOperations
  extend ActiveSupport::Concern
  def decode_token(token)
    return JWT.decode token, nil, false
  end

  def token(token)
    token ? decoded_token(token) : " "
  end

  def token_session(token)
    token ? decoded_token(token).client_session : SecureRandom.hex(16).encode!(Encoding::UTF_8)
  end
end
