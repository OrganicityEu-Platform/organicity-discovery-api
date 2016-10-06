class V0::AssetsController < ApplicationController
  include MapParameters
  include JwtOperations

  #
  # Return assets collection
  #
  # /assets/
  #
  def index
    query_params = map_query_parameters(params)
    @assets = Asset.get_assets(query_params, request, token_session(params[:token]))
    logger.warn @assets
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets by site
  #
  # /assets/sites/:site
  #
  def site
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_site_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets by site in geojson format
  #
  def site_geojson
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_assets", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  #
  # Return assets by experiment id
  #
  # /assets/experiments/:experiment
  #
  def experiment
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_experiment_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets by experimenter id
  #
  # /assets/experimenters/:experimenter
  #
  def experimenter
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_experimenter_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Search assets collection with coordinates and return geojson
  #
  # /assets/geo/search
  #
  def geo_search
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_search_assets", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  #
  # Search assets collection incrementally
  #
  def metadata_search
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_metadata_search_assets", request, token_session(params[:token]))
    logger.warn @assets
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets by service
  #
  # /assets/services/:service
  #
  def service
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_service_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets by provider
  #
  # /assets/providers/:provider
  #
  def provider
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_provider_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets collection in geojson format
  #
  # /assets/geo
  # /assets/sites/:site/geo
  #
  def geo
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_assets", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  #
  # Return assets count for lat and long location. Also take radius as params and perform zoom search based on coords definition. Results are in geojson format.
  #
  # /assets/geo/zoom/:zoom
  #
  def geo_count
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_count_assets", request, token_session(params[:token])))
    render json: @assets
  end

  #
  # Return asset by urn
  #
  # /assets/:urn
  #
  def show
    query_params = map_query_parameters(params)
    @asset = Asset.get_mongo_assets(query_params, "mongo_asset", request, token_session(params[:token]))
    render json: @asset
  end

  #
  # Return asset data
  #
  # /assets/:urn/data
  #
  def data
    query_params = map_query_parameters(params)
    @asset = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_data_asset", request, token_session(params[:token])))
    render json: @asset, each_serializer: AssetDataSerializer, root: false
  end

  #
  # Return assets nearby by given asset
  #
  def nearby
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_asset_nearby", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  def show_ngsiv2
    query_params = map_query_parameters(params)
    @asset = Asset.get_asset(query_params, request, token_session(params[:token]))
    render json: @asset
  end

  def ngsiv2
    query_params = map_query_parameters(params)
    @assets = Asset.get_v2_assets(query_params, request, token_session(params[:token]))
    render json: @assets
  end
end
