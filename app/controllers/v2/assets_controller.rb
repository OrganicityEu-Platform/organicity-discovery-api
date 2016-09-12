class V2::AssetsController < ApplicationController
  include MapParameters
  include JwtOperations
  #
  # Return assets collection with v2 Orion format
  #
  def index
    query_params = map_query_parameters(params)
    @assets = Asset.get_v2_assets(query_params)
    render json: @assets
  end

  def show  
    query_params = map_query_parameters(params)
    @asset = Asset.get_asset(query_params, request, token_session(params[:token]))
    render json: @asset
  end

end
