require 'chronic'

module AssetsMapping
  extend ActiveSupport::Concern

  module ClassMethods

    def mongo_map_geo_assets(assets)
      @assets = assets.map {
        |a| {
          id: a["_id"]["id"],
          type: map_type(a),
          last_updated_at: map_time_instant_to_iso(map_time_instant(a)),
          position: map_position(a),
          reputation: map_reputation(a),
          scope: map_access_scope(a),
          geo: map_geo_attrs(a),
        }
      }
      @assets.group_by { |a| a[:type].downcase }.values
    end

    def mongo_map_data_assets(assets)
      @assets = assets.map {
        |a| {
          id: a["_id"]["id"],
          type: map_type(a),
          last_updated_at: map_time_instant_to_iso(map_time_instant(a)),
          reputation: map_reputation(a),
          scope: map_access_scope(a),
          data: map_data(a)
        }
      }
    end

    def mongo_map_count_assets(raw_assets, params)
      city_name = map_city_from_coords(params[:long], params[:lat])
      {
        type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [
            params[:long].to_f,
            params[:lat].to_f
          ]
        },
        properties: {
          count: raw_assets,
          id: "sites/#{city_name}",
          name: "Cluster #{city_name}",
          city: city_name,
          last_updated_at: Time.now
        }
      }
    end

    def map_city_from_coords(long, lat)
      city = City.nearby(long, lat).first
      if city
        return city.name
      else
        return " "
      end
    end

    def mongo_map_metadata_assets(assets)
      @assets = assets.map {
        |a| {
          id: a["_id"]["id"],
          type: map_type(a),
          last_updated_at: map_time_instant_to_iso(map_time_instant(a)),
          position: map_position(a),
          geo: map_geo_attrs(a),
          provider: map_provider(a),
          data: map_data(a)
        }
      }
    end

    def mongo_map_assets(assets)
      @assets = assets.map {
        |a| {
          id: a["_id"]["id"],
          type: map_type(a),
          last_updated_at:  map_time_instant_to_iso(map_time_instant(a)),
          reputation: map_reputation(a),
          scope: map_access_scope(a),
          position: map_position(a),
          geo: map_geo_attrs(a),
          provider: map_provider(a),
          data: map_data(a)
        }
      }
      if @assets.length == 1
        return @assets.map {
          |a| {
            id: a[:id],
            type: a[:type],
            context: map_context(a),
            related: map_related(a),
            data: a[:data]
          }
        }.first
      else
        return @assets.map {
          |a| {
            id: a[:id],
            type: a[:type],
            context: map_context(a),
            related: map_related(a)
          }
        }
      end
    end

    def map_type(a)
      a["_id"]["type"]
      # return Asset.query_dictionary("assettypes/#{type}") This is for when we will actually have types :D
    end

    def map_data(a)
        {
          attributes:
            {
              types: a["attrNames"],
              data: map_attributes(a["attrs"])
            }
        }
    end


    def map_access_scope(a)
       return (a["attrs"]["access:scope"] && a["attrs"]["access:scope"]["value"]) ?  a["attrs"]["access:scope"]["value"] : "public"
    end

    def map_reputation(a)
       return (a["attrs"]["reputation"] && is_number?(a["attrs"]["reputation"]["value"])) ? a["attrs"]["reputation"]["value"].to_f : "null"
    end

    def map_attributes(attrs)
      data = {}
      attrs.each do |key, value|
        data[key] = {
          name: data_id_to_name(key),
          type: value["type"],
          value: value["value"],
          created_at: map_time_instant_to_iso(value["creDate"]),
          updated_at: map_time_instant_to_iso(value["modDate"])
        }
      end
      return data
    end

    def data_id_to_name(id)
      return id.gsub( ':', ' ').gsub(/[a-zA-Z](?=[A-Z])/, '\0 ').downcase
    end

    def map_attributes_dictionary(attrs)
      types = []
      attrs.each do |attr|
        resp = Asset.query_dictionary("attributetypes/#{attr}")
        types.push(resp)
      end
    end

    def map_geo_attrs(a)
      if a["attrs"]["location"]
        if a["attrs"]["location"]["type"] == "geo:polygon"
          {
            type: "Polygon",
            coordinates: a["attrs"]["location"]["value"].split(',')
          }
        end
      end
    end

    #urn:oc:entity:experimenters:{experimenterID}:{experimentID}:{assetName}
    #urn:oc:entity:{site}:{service}:{provider}:{group}:{entityName}

    def map_context(a)
      if !is_experiment(a)
          {
          service: map_service(a),
          provider: a[:provider],
          group: map_group(a),
          name: map_name(a),
          reputation: a[:reputation],
          scope: a[:scope],
          last_updated_at: a[:last_updated_at],
          position: expand_position(a),
        }
      else
        {
          experimenter: map_service(a),
          experiment: a[:provider],
          name: map_name(a),
          reputation: a[:reputation],
          scope: a[:scope],
          last_updated_at: a[:last_updated_at],
          position: expand_position(a)
        }
      end
    end

    def map_related(a)
      if !is_experiment(a)
        {
          service: map_service(a),
          provider: a[:provider],
          group: map_group(a),
          site: map_site(a)
        }
      else
        {
          experiments: "null"
        }
      end 
    end

    def map_group(a)
      parts = a[:id].split(':')

      #urn:oc:entity:{site}:{service}:{provider}:{group}:{entityName}
      #{group}: Is optional

      if parts.length < 8 # group is optional. there is no group.
        return "null"
      else
        return parts[-2]
      end
    end

    def map_name(a)
      return a[:id].split(':').last
    end

    def map_service(a)
      return a[:id].split(':')[4]
    end

    def is_experiment(a)
      return a[:id].split(':')[3] == "experimenters" ? true : false
    end

    def map_provider(a)
      return a["_id"]["id"].split(':')[5]
    end

    def map_site(a)
      if a[:position] and a[:position] != "null" and a[:position][:city]
        {
          id: a[:position][:city][:attributes][:name].downcase,
          name: a[:position][:city][:attributes][:name],
          description: a[:position][:city][:attributes][:description],
          position: {
            latitude: map_string_to_float(a[:position][:city][:attributes][:latitude]),
            longitude: map_string_to_float(a[:position][:city][:attributes][:longitude])
          },
          links: links_object(a)
        }
      end
    end

    def links_object(a)
      Hash[*a[:position][:city][:links].map { |link|  [link[:relationship], { href: link[:url] } ] }.flatten]
    end

    def expand_position(a)
      if a[:position] and a[:position] != "null" and map_string_to_float(a[:position][:latitude])
        if a[:position][:city]
          {
            latitude: map_string_to_float(a[:position][:latitude]),
            longitude: map_string_to_float(a[:position][:longitude]),
            city: a[:position][:city][:attributes][:name],
            region: a[:position][:city][:attributes][:region],
            country_code: a[:position][:city][:attributes][:country_code],
            country: a[:position][:city][:attributes][:country],
          }
        else
          {
            latitude: map_string_to_float(a[:position][:latitude]),
            longitude: map_string_to_float(a[:position][:longitude])
          }
        end
      else
        nil
      end
    end

    def map_position(a)
      city = City.where(name: "#{a["_id"]["id"].split(':')[3].capitalize}").includes(:links).map { |c| {attributes: c, links: c.links} }.first
      
      if a["attrs"]["position"] and a["attrs"]["position"]["type"] == "coords"
        {
          longitude: a["attrs"]["position"]["value"].split(',')[1],
          latitude: a["attrs"]["position"]["value"].split(',')[0],
          city: city
        }
      elsif a["attrs"]["latitude"] and a["attrs"]["longitude"]
        {
          longitude: a["attrs"]["longitude"]["value"],
          latitude: a["attrs"]["latitude"]["value"],
          city: city
        }
      # This is temp. Geojson requires a complete implementation
      elsif a["attrs"]["location"] and a["attrs"]["location"]["type"] == "geo:json"
        if a["attrs"]["location"]["value"]["type"] == "Point" 
          {
            longitude: a["attrs"]["location"]["value"]["coordinates"].split(',')[0],
            latitude: a["attrs"]["location"]["value"]["coordinates"].split(',')[1],
            city: city
          }
        #This is temp
        else 
          {
            longitude: city_position(city)[0],
            latitude: city_position(city)[1],
            city: city
          }        
        end
      elsif a["attrs"]["location"]
        {
          longitude: a["attrs"]["location"]["value"].split(',')[0],
          latitude: a["attrs"]["location"]["value"].split(',')[1],
          city: city
        }
      elsif a["location"] and a["location"]["coords"]
        {
          longitude: a["location"]["coords"]["coordinates"][1],
          latitude: a["location"]["coords"]["coordinates"][0],
          city: city
        }
      else
        {
          longitude: city_position(city)[0],
          latitude: city_position(city)[1],
          city: city
        }
      end
    end

    def city_position(city)
      if city
        [ city[:attributes][:longitude].to_f, city[:attributes][:latitude].to_f ]
      else
        "null"
      end
    end

    def map_orion_position(a)
      @city = City.where(name: "#{a["id"].split(':')[3].capitalize}").includes(:links)
      if a["position"] and a["position"]["value"] and a["position"]["type"] == "coords"
        {
          longitude: a["position"]["value"].split(',')[1],
          latitude: a["position"]["value"].split(',')[0],
          city: @city.map { |c| {attributes: c, links: c.links} }.first
        }
      elsif a["position"] and a["position"]["value"] and a["position"]["type"] == "geo:json"
        {
          longitude: a["position"]["value"].split(',')[0],
          latitude: a["position"]["value"].split(',')[1],
          city: @city.map { |c| {attributes: c, links: c.links} }.first
        }
      else
        if @city[0]
          {
            longitude: @city[0].longitude,
            latitude: @city[0].latitude,
            city: @city.map { |c| {attributes: c, links: c.links} }.first
          }
        else
          "null"
        end
      end
    end

    def map_orion_time_instant(a)
      if a["TimeInstant"]
        return a["TimeInstant"]["value"]
      elsif a["modDate"]
        return a["modDate"]
      elsif a["creDate"]
        return a["creDate"]
      else
        return "null"
      end
    end

    def map_time_instant_to_iso(a)
      if is_number?(a)  
        return Time.at(Integer(a)).utc.iso8601 rescue "null"
      else
        return Chronic.parse(a).utc.iso8601 rescue "null"
      end
    end

    def map_string_to_float(a)
      if is_number?(a)                             
        return Float(a) rescue "null"
      else
        return nil
      end
    end

    def is_number? string
      true if Float(string) rescue false
    end

    def map_time_instant(a)
      if a["attrs"]["TimeInstant"]
        return a["attrs"]["TimeInstant"]["value"]
      elsif a["attrs"]["modDate"]
        return a["attrs"]["modDate"]
      elsif a["modDate"]
        return a["modDate"]
      elsif a["creDate"]
        return a["creDate"]
      else
        return "null"
      end
    end
  end
end
