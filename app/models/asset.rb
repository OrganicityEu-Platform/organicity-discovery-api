class Asset < ApplicationRecord
  extend Restful
  extend Orion

  def self.get_assets
    @assets = Asset.request_entities
    return @assets.doc.map {
      |a| {
        id: a["id"],
        last_reading_at: a["TimeInstant"]["value"],
        position: {
          latitude: a["position"]["value"].split(',')[0],
          longitude: a["position"]["value"].split(',')[1],
          city: City.where(name: a["id"].split(':')[-4].capitalize).first,
        }
      }
    }
  end
end
