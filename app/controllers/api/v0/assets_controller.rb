class Api::V0::AssetsController < ApplicationController
  include MapParameters

  #
  # Return assets collection
  #
  def index
    query_params = map_query_parameters(params)
    logger.info params
    @assets = Asset.get_mongo_assets(query_params)
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def show
    @asset = Asset.get_mongo_asset(params[:id])
    render json: @asset, serializer: AssetSerializer, root: false
  end

  def site
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_site_assets(query_params)
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def geo
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_geo_search_assets(query_params)
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def service
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_service_assets(query_params)
    render json: @assets, each_serializer: AssetSerializer, root: false
  end
end
