class Asset < ApplicationRecord
  extend Restful
  extend Orion
  extend MongoOrionClient

  def self.get_assets(params)
    logger.info "in asset.rb get_assets params are: #{params.to_json}"
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

    return JSON.parse(@cached_call.response)
  end

  def self.get_mongo_geo_search_assets(params)
    assets = []
    call = self.cache_mongo(params, "geo_search_assets")
    if call
      assets = JSON.parse(call.response)
    else
      raw_assets = self.query_mongo_geo_search(params)
      assets = self.mongo_map_assets(raw_assets)
      log assets
      @cached_call = RestCall.create(params: params, endpoint: "geo_search_assets", created_at: Time.now, response: assets.to_json)
    end
    return assets
  end

  def self.get_mongo_site_assets(params)
    assets = []
    call = self.cache_mongo(params, "site_assets")
    if call
      assets = JSON.parse(call.response)
    else
      raw_assets = self.query_mongo_site_entities(params)
      assets = self.mongo_map_assets(raw_assets)
      log assets
      @cached_call = RestCall.create(params: params, endpoint: "site_assets", created_at: Time.now, response: assets.to_json)
    end
    return assets
  end

  def self.get_mongo_assets(params)
    assets = []
    call = self.cache_mongo(params, "mongo_assets")
    if call
      assets = JSON.parse(call.response)
    else
      raw_assets = self.query_mongo_entities(params)
      assets = self.mongo_map_assets(raw_assets)
      log assets
      @cached_call = RestCall.create(params: params, endpoint: "mongo_assets", created_at: Time.now, response: assets.to_json)
    end
    return assets
  end

  def self.mongo_map_assets(assets)
    return assets.map {
      |a| {
        id: a["_id"]["id"],
        last_reading_at: self.map_time_instant(a),
        position: self.map_position(a)
      }
    }
  end

  def self.map_position(a)
    if a["attrs"]["position"]
      {
        latitude: a["attrs"]["position"]["value"].split(',')[0],
        longitude: a["attrs"]["position"]["value"].split(',')[1],
        city: City.where(name: "#{a["_id"]["id"].split(':')[3].capitalize}").includes(:links).map { |c| {attributes: c, links: c.links} }.first
      }
    else
      nil
    end
  end

  def self.map_time_instant(a)
    if a["attrs"]["TimeInstant"]
      return a["attrs"]["TimeInstant"]["value"]
    elsif a["attrs"]["modDate"]
      return a["attrs"]["modDate"]
    else
      return nil
    end
  end
end
