class V0::AssetsController < ApplicationController
  include MapParameters
  include JwtOperations

  #
  # Return assets collection
  #
  # /assets/
  #
  def index
    logger.warn "index"
    query_params = map_query_parameters(params)
    @assets = Asset.get_assets(query_params, request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets by site
  #
  # /assets/sites/:site
  #
  def site
    logger.warn "site"
    query_params = map_query_parameters(params)
    @assets = Asset.get_mongo_assets(query_params, "mongo_site_assets", request, token_session(params[:token]))
    render json: @assets, each_serializer: AssetSerializer, root: false
  end

  #
  # Return assets by site in geojson format
  #
  def site_geojson
    logger.warn ":site/geo"
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
    logger.warn "experiment"
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
    logger.warn "experimenter"
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
    logger.warn "geo search"
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_geo_search_assets", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  #
  # Search assets collection incrementally
  #
  def metadata_search
    logger.warn "metadata/search"
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
    logger.warn "service"
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
    logger.warn "provider"
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
    logger.warn "geo"
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
    logger.warn "geo count"
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
    logger.warn "show :id"
    query_params = map_query_parameters(params)
    @asset = Asset.get_mongo_assets(query_params, "mongo_asset", request, token_session(params[:token]))
    logger.warn @asset
    if @asset.to_s == "[]"
      render json: {error: {status: 404, message: 'Not found'}}
    else
      render json: @asset
    end
  end

  #
  # Return asset data
  #
  # /assets/:urn/data
  #
  def data
    logger.warn ":id/data"
    query_params = map_query_parameters(params)
    @asset = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_data_asset", request, token_session(params[:token])))
    if @asset.to_s == "[]"
      render json: {error: {status: 404, message: 'Not found'}}
    else
      render json: @asset, each_serializer: AssetDataSerializer, root: false
    end
  end

  #
  # Return assets nearby by given asset
  #
  def nearby
    logger.warn ":id/nearby"
    query_params = map_query_parameters(params)
    @assets = JSON.parse(Asset.get_mongo_assets(query_params, "mongo_asset_nearby", request, token_session(params[:token])))
    render json: @assets, each_serializer: AssetGeoSerializer, root: false
  end

  def show_ngsiv2
    logger.warn ":id/ngsiv2"
    query_params = map_query_parameters(params)
    @asset = Asset.get_asset(query_params, request, token_session(params[:token]))
    if @asset["doc"]
      render json: @asset["doc"]
    else
      render json: @asset
    end
  end

  def ngsiv2
    logger.warn "assets/ngsiv2"
    query_params = map_query_parameters(params)
    @assets = Asset.get_v2_assets(query_params, request, token_session(params[:token]))
    render json: @assets["doc"]
  end
end
