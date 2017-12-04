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

  def self.get_mongo_assets(params, endpoint, request = false, session = false)

    # If we are logged in with a Bearer token, use it to get prefixes before we search
    # This code was moved from application_controller#http_auth
    if request.headers['Authorization'].present?
      if request.headers['Authorization'].split(' ').first == 'Bearer'
        authheader = request.headers['Authorization']

        # In the token lives a 'sub' which is a client id?
        client_token = request.headers['Authorization'].split(' ').last
        cli_decoded = JWT.decode client_token, nil, false
        sub = cli_decoded.first["sub"]
      else
        logger.warn '-- no Bearer token, but could be Basic token'
      end
    end

    # cities_whitelist should be: ['urn:oc:entity:santander','urn:oc:entity:london','urn:oc:entity:patras','urn:oc:entity:aarhus']
    # NOTE: cities are empty if DB has not been seeded.
    cities_whitelist = Array.new
    City.pluck(:name).map do |c|
      if c.is_a? String
        cities_whitelist.push 'urn:oc:entity:' + c.to_s.downcase
      end
    end

    # Get all prefixes, depending on this users header-authtoken
    # myprefixes is an array of:
    # urn:oc:entity:experimenters:86d7edce-5092-44c0-bed8-da4beaa3fbc6:58a1e36cc2f43c7c37d178dc
    # It will return empty if experimenters.organicity does not respond within 5 sec
    myprefixes = get_prefixes(authheader) # (authheader will be nil if user is not logged in)
    logger.warn ("Nr of prefixes: #{myprefixes.length}") if myprefixes.present?

    if myprefixes.present?
      params[:prefixes] = myprefixes + cities_whitelist
    else
      params[:prefixes] = cities_whitelist
    end

    #TODO: Should we also check if we have 'sub' ?
    if request && session
      # Logs to mongo

      urn = nil
      if params[:id]
         urn = params[:id]
      end
      self.mongo_orion_logger(request, session, urn, sub)
    end

    logger.warn "Endpoint: #{endpoint}"
    logger.warn "Params: #{params}"

    cache_log = Logger.new('log/cache.log')
    cache_log.level = Logger::INFO

    Rails.cache.fetch("#{endpoint}/#{params}", expires_in: 20.seconds) do
      cache_log.info "New cache for assets"
      assets = []

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
    end
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
