require 'json'

class Asset < ApplicationRecord
  include AssetsMapping

  extend Restful
  extend Orion
  extend MongoOrionClient

  def self.get_assets(params)
    # Use Orion APIs
    assets = self.request_entities(params)
    return assets["doc"].map {
      |a| {
        id: a["id"],
        last_reading_at: a["TimeInstant"]["value"],
        position: {
          latitude: a["position"]["value"].split(',')[0],
          longitude: a["position"]["value"].split(',')[1],
          city: City.where(name: "#{a["id"].split(':')[-4].capitalize}").includes(:links).map { |c| {attributes: c, links: c.links} }.first
        }
      }
    }
  end

  def self.cache_mongo(params, endpoint)
    call = RestCall.find(params: params, endpoint: endpoint).sort(by: :created_at)
    log "call: #{call.last.created_at}" unless call.empty?
    if call.empty? or ( Time.now > Time.parse(call.last.created_at) + 10.minutes )
      # We should extend cache if there is an error to preserve good results
      log "new request"
      return false
    else
      log "cached response"
      return call.last
    end
  end

  def self.get_mongo_geo_search_assets(params)
    assets = []
    call = self.cache_mongo(params, "geo_search_assets")
    if call
      assets = call.response
      log assets
    else
      raw_assets = self.query_mongo_geo_search(params)
      assets = self.mongo_map_assets(raw_assets).to_json
      log assets
      @cached_call = RestCall.create(params: params, endpoint: "geo_search_assets", created_at: Time.now, response: assets)
    end
    return assets
  end

  def self.get_mongo_service_assets(params)
    assets = []
    call = self.cache_mongo(params, "service_assets")
    if call
      assets = call.response
      log assets
    else
      raw_assets = self.query_mongo_service_entities(params)
      assets = self.mongo_map_assets(raw_assets).to_json
      log assets
      @cached_call = RestCall.create(params: params, endpoint: "service_assets", created_at: Time.now, response: assets)
    end
    return assets
  end

  def self.get_mongo_site_assets(params)
    assets = []
    call = self.cache_mongo(params, "site_assets")
    if call
      assets = call.response
      log assets
    else
      raw_assets = self.query_mongo_site_entities(params)
      assets = self.mongo_map_assets(raw_assets).to_json
      log assets
      @cached_call = RestCall.create(params: params, endpoint: "site_assets", created_at: Time.now, response: assets)
    end
    return assets
  end

  def self.get_mongo_assets(params)
    assets = []
    call = self.cache_mongo(params, "mongo_assets")
    if call
      assets = call.response
      log assets
    else
      raw_assets = self.query_mongo_entities(params)
      assets = self.mongo_map_assets(raw_assets).to_json
      log assets
      @cached_call = RestCall.create(params: params, endpoint: "mongo_assets", created_at: Time.now, response: assets)
    end
    return assets
  end

  def self.get_mongo_asset(params)
    asset = []
    call = self.cache_mongo(params, "mongo_asset")
    if call
      asset = call.response
      log asset
    else
      raw_asset = self.query_mongo_entity(params)
      log raw_asset
      asset = self.mongo_map_assets(raw_asset).to_json
      log asset
      @cached_call = RestCall.create(params: params, endpoint: "mongo_assets", created_at: Time.now, response: asset)
    end
    return asset
  end
end
