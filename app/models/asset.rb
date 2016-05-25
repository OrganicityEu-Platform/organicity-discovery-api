class Asset < ApplicationRecord
  extend Restful
  extend Orion

  def self.get_assets(params)

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
end
