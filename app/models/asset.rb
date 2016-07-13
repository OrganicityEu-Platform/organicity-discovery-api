require 'json'

class Asset < ApplicationRecord
  include AssetsMapping

  extend Restful
  extend Orion
  extend MongoOrionClient

  def self.get_assets(params)
    # Use Orion APIs
    # Cache should be moved to model level.
    assets = self.request_entities(params)
    return assets["doc"].map {
      |a| {
        id: a["id"],
        last_updated_at: map_orion_time_instant(a),
        position: map_orion_position(a)
      }
    }
  end

  def self.cache_mongo(params, endpoint)
    call = RestCall.find(params: params, endpoint: endpoint).sort(by: :created_at)
    logger.warn "call: #{call.last.created_at}" unless call.empty?
    if call.empty? or ( Time.now > Time.parse(call.last.created_at) + 10.minutes )
      # We should extend cache if there is an error to preserve good results
      logger.warn "new request"
      return false
    else
      logger.warn "cached response"
      return call.last
    end
  end

  def self.get_mongo_assets(params, endpoint)
    assets = []
    call = self.cache_mongo(params, endpoint)
    if call
      assets = call.response
    else
      if (endpoint == "mongo_asset" or endpoint == "mongo_geo_assets" or endpoint == "mongo_data_assets")
        raw_assets = self.send("#{endpoint}", params)
      else
        raw_assets = self.mongo_assets(params)
      end

      if endpoint == "mongo_geo_assets"
        assets = self.mongo_map_geo_assets(raw_assets).to_json
      elsif endpoint == "mongo_data_asset"
        assets = self.mongo_map_data_assets(raw_assets).to_json
      else
        assets = self.mongo_map_assets(raw_assets).to_json
      end
      @cached_call = RestCall.create(params: params, endpoint: endpoint, created_at: Time.now, response: assets)
    end
    return assets
  end
end
