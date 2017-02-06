class ApplicationController < ActionController::API

  before_action :cors_preflight_check, :http_auth_header

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token, Authorization'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  def http_auth_header
      if Rails.configuration.auth_enabled and request.headers['Authorization'].present?
        params[:token] = request.headers['Authorization'].split(' ').last
      end
  end

end
