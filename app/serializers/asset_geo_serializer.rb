require 'time'

class AssetGeoSerializer < ActiveModel::Serializer
  attributes :type, :properties
  attribute :data, key: :features

  def type
    "FeatureCollection"
  end

  def properties
    {
      name: object.first["type"]
    }
  end

  def data
    object.map { |o| feature(o) }
  end

  def feature(o)
    # TODO: Implement a complex geometry
    # http://localhost:3000/v0/assets/geo/search?lat=43.4&long=-3.84&radius=50&km=true
    {
      type: "Feature",
      geometry: o["position"]["geometry"],
      properties: feature_properties(o)
    }
  end

  def feature_properties(o)
    {
      id: o["id"],
      type: o["type"],
      name: map_name(o),
      last_update_at: o["last_updated_at"],
      provider: map_provider(o),
      group: map_group(o),
      service: map_service(o),
      scope: o["scope"],
      reputation: o["reputation"]
    }
  end

  def map_name(a)
    return a["id"].split(':').last
  end

  def map_provider(a)
    return a["id"].split(':')[5]
  end

  def map_service(a)
    return a["id"].split(':')[4]
  end

  def map_group(a)
    parts = a["id"].split(':')

    #urn:oc:entity:{site}:{service}:{provider}:{group}:{entityName}
    #{group}: Is optional

    if parts.length < 8 # group is optional. there is no group.
      return "null"
    else
      return parts[-2]
    end
  end

end
