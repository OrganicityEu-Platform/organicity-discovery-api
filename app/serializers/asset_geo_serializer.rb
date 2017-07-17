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
      geometry: geometry(o),
      properties: feature_properties(o)
    }
  end

  def map_type(o)
    #puts JSON.pretty_generate(o)
    if o["geo"] and o["geo"]["type"]
      o["geo"]["type"]
    elsif true # TODO: how do we know it is a MultiPolygon?
      # Is it when we have more than 1 pairs of coordinates? ex coordinates.length > 2 ?
      "MultiPolygon"
    else
      "Point"
    end
  end

  def geometry(o)
    {
      type: map_type(o),
      coordinates: map_position(o)
    }
  end

  def map_position(o)
    # If the o == MultiPolygon, strip them
    if map_type(o) == 'MultiPolygon'
      p 'We have a MultiPolygon' # downside is we call map_type(o) 2x
    end
    if o["position"]["latitude"] and o["position"]["longitude"]
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
