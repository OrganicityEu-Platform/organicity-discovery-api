class V0::AssetsController < ApplicationController
  include MapParameters

  #
  # Return assets collection
  #
  def index
    query_params = map_query_parameters(params)
    @assets = Asset.get_assets(query_params)
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def site
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_site_assets")
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def geo
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_geo_search_assets")
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def service
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_service_assets")
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def provider
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_provider_assets")
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def lightweight
    query_params = map_query_parameters(params)
    @assets = Asset.get_assets(query_params)
    render json: @assets, each_serializer: AssetLightWeightSerializer, root: false
  end

  def show
    query_params = map_query_parameters(params)
    @asset = Asset.get_mongo_assets(query_params, "mongo_asset")
    render json: @asset
  end
end
