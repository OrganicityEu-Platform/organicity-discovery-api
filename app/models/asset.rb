require 'json'
require 'jwt'

class Asset < ApplicationRecord
  include AssetsMapping

  extend Restful
  extend Orion
  extend MongoOrionClient
  extend Accounts
  extend Dictionary
  extend Prefixes

  def self.get_assets(params, request, session)
    # Logs to mongo
    self.mongo_orion_logger(request, session)
    # Use Orion APIs
    assets = self.request_entities(params)
    return assets["doc"].map {
      |a| {
        id: a["id"],
        last_updated_at: map_time_instant_to_iso(map_orion_time_instant(a)),
        reputation: a["reputation"],
        position: map_orion_position(a)
      }
    }
  end

  def self.get_asset(params, request, session)
    # Logs to mongo
    self.mongo_orion_logger(request, session)
    # Use Orion APIs
    asset = self.request_entity(params)
    return asset
  end

  def self.get_v2_assets(params, request, session)
    self.mongo_orion_logger(request, session)
    # Use Orion APIs
    return self.request_entities(params)
  end

  def self.cache_mongo(params, endpoint)
    call = RestCall.find(params: params, endpoint: endpoint).sort(by: :created_at)
    logger.warn "call: #{call.last.created_at}" unless call.empty?
    logger.warn 'call:'
    logger.warn call
    if call.empty? or ( Time.now > Time.parse(call.last.created_at) + 30.seconds )
      # We should extend cache if there is an error to preserve good results
      logger.warn "new request"
      return false
    else
      logger.warn "cached response"
      return call.last
    end
  end

  def self.get_mongo_assets(params, endpoint, request = false, session = false)

    # If we are logged in with a Bearer token, use it to get prefixes before we search
    # This code was moved from application_controller#http_auth
    if request.headers['Authorization'].present?
      if request.headers['Authorization'].split(' ').first == 'Bearer'
        myheader = request.headers['Authorization']

        # In the token lives a 'sub' which is a client id?
        client_token = request.headers['Authorization'].split(' ').last
        cli_decoded = JWT.decode client_token, nil, false
        sub = cli_decoded.first["sub"]
      else
        logger.warn '-- no Bearer token, but could be Basic token'
      end
    end

    # Sites whitelist should be: ['urn:oc:entity:santander','urn:oc:entity:london','urn:oc:entity:patras','urn:oc:entity:aarhus']
    # TODO
    whitelist = City.pluck(:name).map do |c|
      'urn:oc:entity:' + c.to_s.downcase
    end

    # Get all prefixes
    # myprefixes is an array of:
    # urn:oc:entity:experimenters:86d7edce-5092-44c0-bed8-da4beaa3fbc6:58a1e36cc2f43c7c37d178dc
    myprefixes = getPrefixes(myheader) # (myheader may be nil.)
    logger.warn ("Nr of prefixes: #{myprefixes.length}") if myprefixes.present?

    params[:prefixes] = myprefixes + whitelist

    #TODO: Should we also check if we have 'sub' ?
    if request && session
      # Logs to mongo

      urn = nil
      if params[:id]
         urn = params[:id]
      end
      self.mongo_orion_logger(request, session, urn, sub)
    end

    assets = []

    logger.warn "Endpoint: #{endpoint}"
    logger.warn "Params: #{params}"

    call = self.cache_mongo(params, endpoint)

    # TODO: The commented code can be removed

    # if call
    #   assets = call.response
    #   logger.warn "Cached assets: #{assets}"
    # else
      # How to retrieve assets
      if (self.mongo_endpoints.include? endpoint)
        raw_assets = self.send("#{endpoint}", params) # This calls mongo_orion_client dedicated functions based on the endpoint name
      else
        raw_assets = self.mongo_assets(params) # This calls the generic mongo_orion_client mongo_assets function
      end
      # How to map assets
    if ["mongo_geo_assets", "mongo_geo_search_assets", "mongo_asset_nearby", "mongo_geo_site_assets"].include? endpoint
      assets = self.mongo_map_geo_assets(raw_assets).to_json
    elsif endpoint == "mongo_data_asset"
      assets = self.mongo_map_data_assets(raw_assets).to_json
    elsif endpoint == "mongo_geo_count_assets"
      assets = self.mongo_map_count_assets(raw_assets, params).to_json
    else 
      assets = self.mongo_map_assets(raw_assets).to_json
    end
      # @cached_call = RestCall.create(params: params, endpoint: endpoint, created_at: Time.now, response: assets)
    # end
    return assets
  end

  private
    def self.mongo_endpoints
      [
        "mongo_geo_count_assets",
        "mongo_geo_assets",
        "mongo_geo_search_assets",
        "mongo_metadata_search_assets",
        "mongo_asset_nearby",
      ]
    end
end
