require 'json'

class Asset < ApplicationRecord
  include AssetsMapping

  extend Restful
  extend Orion
  extend MongoOrionClient
  extend Accounts
  extend Dictionary

  def self.get_assets(params, request, session)
    # Logs to mongo
    self.mongo_orion_logger(request, session)
    # Use Orion APIs
    assets = self.request_entities(params)
    return assets["doc"].map {
      |a| {
        id: a["id"],
        last_updated_at: map_orion_time_instant(a),
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

  def self.get_mongo_assets(params, endpoint, request, session)
    # Logs to mongo
    self.mongo_orion_logger(request, session)

    assets = []
    logger.warn "Params: #{params}"
    call = self.cache_mongo(params, endpoint)
    if call
      assets = call.response
      logger.warn "Cached assets: #{assets}"
    else
      # How to retrieve assets
      if (self.mongo_endpoints.include? endpoint)
        raw_assets = self.send("#{endpoint}", params)
      else
        raw_assets = self.mongo_assets(params)
      end
      # How to map assets
      if ["mongo_geo_assets", "mongo_geo_search_assets", "mongo_asset_nearby", "mongo_geo_assets"].include? endpoint
        assets = self.mongo_map_geo_assets(raw_assets).to_json
      elsif endpoint == "mongo_data_asset"
        assets = self.mongo_map_data_assets(raw_assets).to_json
      elsif endpoint == "mongo_geo_count_assets"
        assets = self.mongo_map_count_assets(raw_assets, params).to_json
      elsif endpoint == "mongo_metadata_search_assets"
        assets = self.mongo_map_metadata_assets(raw_assets).to_json
      else
        assets = self.mongo_map_assets(raw_assets).to_json
      end
      @cached_call = RestCall.create(params: params, endpoint: endpoint, created_at: Time.now, response: assets)
    end
    return assets
  end

  private
    def self.mongo_endpoints
      [
        "mongo_asset",
        "mongo_geo_count_assets",
        "mongo_geo_assets",
        "mongo_geo_search_assets",
        "mongo_metadata_search_assets",
        "mongo_asset_nearby",
        "mongo_data_asset"
      ]
    end
end
