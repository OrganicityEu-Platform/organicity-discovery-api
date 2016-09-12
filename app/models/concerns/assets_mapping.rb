module AssetsMapping
  extend ActiveSupport::Concern

  module ClassMethods

    def mongo_map_geo_assets(assets)
      @assets = assets.map {
        |a| {
          id: a["_id"]["id"],
          type: map_type(a),
          last_updated_at: map_time_instant(a),
          position: map_position(a),
          reputation: a["attrs"]["reputation"],
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
          last_updated_at: map_time_instant(a),
          reputation: a["attrs"]["reputation"],
          data: map_data(a)
        }
      }
    end

    def mongo_map_count_assets(raw_assets, params)
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
          name: "Cluster",
          last_updated_at: Time.now
        }
      }
    end

    def map_city_from_coords(long, lat)
      city = City.where(:lonlat => "POINT(#{long} #{lat})").first
      if city
        return city.name
      else
        return " "
      end
    end

    def mongo_map_assets(assets)

      @assets = assets.map {
        |a| {
          id: a["_id"]["id"],
          type: map_type(a),
          last_updated_at: map_time_instant(a),
          position: map_position(a),
          geo: map_geo_attrs(a),
          provider: a["_id"]["id"].split(':')[-2],
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
    end

    def map_data(a)
        {
          context:
            {
              time_instant: a["TimeInstant"],
              created_at: a["creDate"],
              updated_at: a["modDate"]
            },
          attributes:
            {
              types: a["attrNames"],
              data: a["attrs"]
            }
        }
    end

    def map_geo_attrs(a)
      if a["attrs"]["location"]
        if a["attrs"]["location"]["type"] == "geo:polygon"
          {
            type: "Polygon",
            coordinates: a["attrs"]["location"]["value"].split(',').each_slice(2).to_a
          }
        end
      end
    end
    def map_context(a)
      {
        service: a[:type],
        provider: a[:provider],
        group: "null",
        name: a[:id],
        last_updated_at: a[:last_updated_at],
        position: expand_position(a),
        reputation: a["attrs"]["reputation"],
        geo: a[:geo]
      }
    end

    def map_related(a)
      {
        service: a[:type],
        provider: a[:provider],
        group: "null",
        site: map_site(a),
      }
    end

    def map_site(a)
      if a[:position] and a[:position] != "null" and a[:position][:city]
        {
          id: a[:position][:city][:attributes][:name].downcase,
          name: a[:position][:city][:attributes][:name],
          description: a[:position][:city][:attributes][:description],
          position: [ a[:position][:city][:attributes][:longitude].to_f, a[:position][:city][:attributes][:latitude].to_f ],
          links: links_object(a).to_json
        }
      end
    end

    def links_object(a)
      Hash[*a[:position][:city][:links].map { |link|  [link[:relationship], { href: link[:url] } ] }.flatten]
    end

    def expand_position(a)
      if a[:position] and a[:position] != "null"
        if a[:position][:city]
          {
            latitude: a[:position][:latitude],
            longitude: a[:position][:longitude],
            city: a[:position][:city][:attributes][:name],
            region: a[:position][:city][:attributes][:region],
            country_code: a[:position][:city][:attributes][:country_code],
            country: a[:position][:city][:attributes][:country],
          }
        else
          {
            latitude: a[:position][:latitude],
            longitude: a[:position][:longitude]
          }
        end
      else
        nil
      end
    end

    def map_position(a)
      city = City.where(name: "#{a["_id"]["id"].split(':')[3].capitalize}").includes(:links).map { |c| {attributes: c, links: c.links} }.first

      if a["location"] and a["location"]["coords"]
        {
          longitude: a["location"]["coords"]["coordinates"][0],
          latitude: a["location"]["coords"]["coordinates"][1],
          city: city
        }
      elsif a["attrs"]["position"]
        {
          latitude: a["attrs"]["position"]["value"].split(',')[0],
          longitude: a["attrs"]["position"]["value"].split(',')[1],
          city: city
        }
      else
        {
          latitude: city_position(city)[0],
          longitude: city_position(city)[1],
          city: city
        }
      end
    end

    def city_position(city)
      if city
        [ city[:attributes][:latitude].to_f, city[:attributes][:longitude].to_f ]
      else
        "null"
      end
    end

    def map_orion_position(a)
      @city = City.where(name: "#{a["id"].split(':')[3].capitalize}").includes(:links)
      if a["position"] and a["position"]["value"]
        {
          latitude: a["position"]["value"].split(',')[0],
          longitude: a["position"]["value"].split(',')[1],
          city: @city.map { |c| {attributes: c, links: c.links} }.first
        }
      else
        if @city[0]
          {
            latitude: @city[0].latitude,
            longitude: @city[0].longitude,
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
      else
        return "null"
      end
    end

    def map_time_instant(a)
      if a["attrs"]["TimeInstant"]
        return a["attrs"]["TimeInstant"]["value"]
      elsif a["attrs"]["modDate"]
        return a["attrs"]["modDate"]
      else
        return "null"
      end
    end
  end
end
