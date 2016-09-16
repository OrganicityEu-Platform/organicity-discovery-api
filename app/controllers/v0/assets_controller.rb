class V0::AssetsController < ApplicationController
  include MapParameters
  include JwtOperations
  #
  # Return assets collection
  #
  def index
    query_params = map_query_parameters(params)
    @assets = Asset.get_assets(query_params, request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def site
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_site_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def experiment
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_experiment_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def experimenter
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_experimenter_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def geo_search
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_search_assets", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  def service
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_service_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def provider
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_provider_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  def geo
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_assets", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  def geo_count
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_count_assets", request, token_session(params[:token])))
    render json: @assets
  end

  def show
    query_params = map_query_parameters(params)
    @asset = Asset.get_mongo_assets(query_params, "mongo_asset", request, token_session(params[:token]))
    render json: @asset
  end

  def data
    query_params = map_query_parameters(params)
    @asset = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_data_asset", request, token_session(params[:token])))
    render json: @asset, each_serializer: AssetDataSerializer, root: false
  end

  def nearby
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_asset_nearby", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  def v2
    query_params = map_query_parameters(params)
    @asset = Asset.get_asset(query_params, request, token_session(params[:token]))
    render json: @asset
  end
end
