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
    {
      type: "Feature",
      geometry: geometry(o),
      properties: feature_properties(o)
    }
  end

  def map_type(o)
    if o["geo"] and o["geo"]["type"]
      o["geo"]["type"]
    else
      "Point"
    end
  end

  def geometry(o)
    {
      type: map_type(o),
      coordinates: o["position"] ? map_position(o) : nil
    }
  end

  def map_position(o)
    if o["geo"] and o["geo"]["type"] == "Polygon"
      [ o["geo"]["coordinates"].map {|c| [c[0].to_f, c[1].to_f] } ]
    elsif o["position"]["latitude"] and o["position"]["longitude"]
      [
        o["position"]["longitude"].to_f,
        o["position"]["latitude"].to_f
      ]
    else
      [ 0.0, 0.0 ]
    end
  end

  def feature_properties(o)
    {
      id: o["id"],
      type: o["type"],
      name: map_name(o),
      last_update_at: o["last_updated_at"],
      site: o["position"]["city"] ? o["position"]["city"]["attributes"]["name"].downcase : "null",
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
