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

  def self.get_mongo_geo_search_assets(params)
    assets = self.query_mongo_geo_search(params)
    log assets
    return self.mongo_map_assets(assets)
  end

  def self.get_mongo_site_assets(params)
    assets = self.query_mongo_site_entities(params)
    log assets
    return self.mongo_map_assets(assets)
  end

  def self.get_mongo_assets(params)
    assets = self.query_mongo_entities(params)
    log assets
    return self.mongo_map_assets(assets)
  end

  def self.mongo_map_assets(assets)
    return assets.map {
      |a| {
        id: a["_id"]["id"],
        last_reading_at: a["attrs"]["TimeInstant"]["value"],
        position: {
          latitude: a["attrs"]["position"]["value"].split(',')[0],
          longitude: a["attrs"]["position"]["value"].split(',')[1],
          city: City.where(name: "#{a["_id"]["id"].split(':')[3].capitalize}").includes(:links).map { |c| {attributes: c, links: c.links} }.first
        }
      }
    }
  end
end
