class V2::AssetsController < ApplicationController
  include MapParameters

  #
  # Return assets collection with v2 Orion format
  #
  def index
    query_params = map_query_parameters(params)
    @assets = Asset.get_v2_assets(query_params)
    render json: @assets
  end

end
