class Api::V0::AssetsController < ApplicationController
  include MapParameters

  #
  # Return assets collection
  #
  def index
    query_params = map_paramenters(params)
    @assets = Asset.get_assets(query_params)
    render json: @assets, each_serializer: AssetSerializer, root: false
  end
end
