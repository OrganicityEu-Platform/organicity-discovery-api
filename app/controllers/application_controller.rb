class ApplicationController < ActionController::API
  include Prefixes
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
    if request.headers['Authorization'].present?
      if request.headers['Authorization'].split(' ').first == 'Basic'
        # TODO: Do we need the token when using a 'Basic' user|pass login?
        # If the auth header is something like: 'Basic x40chars' instead of 'Bearer x200chars',
        # the jwt decode operation will fail with a:
        # JWT::DecodeError: Not enough or too many segments
        # Because the Basic token does not have 3 sections seperated with a dot .
      elsif request.headers['Authorization'].split(' ').first == 'Bearer'
        # The assets_controller expects params[:token] to exist.
        # It calls jwt_operations#token_session with params[:token]
        # to fetch "client_session" if it exists
        params[:token] = request.headers['Authorization'].split(' ').last

        myprefix = getPrefixes(request.headers['Authorization'])

        puts ("Nr of prefixes: #{myprefix.length}") if myprefix.present?
      else
        #Some other header?
      end
    end
  end

end
