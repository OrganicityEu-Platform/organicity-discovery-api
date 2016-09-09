require 'jwt'

module JwtOperations
  extend ActiveSupport::Concern
  def decode_token(token)
    return decoded_token = JWT.decode token, nil, false
  end

  def token(params[:token])
    params[:token] ? decoded_token(params[:token]) : " "
  end

  def session(params[:token])
    params[:token] ? decoded_token(params[:token]).client_session : SecureRandom.hex(16).encode!(Encoding::UTF_8)
  end
end
