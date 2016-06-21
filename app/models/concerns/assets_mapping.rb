module AssetsMapping
  extend ActiveSupport::Concern

  module ClassMethods
    def mongo_map_assets(assets)

      @assets = assets.map {
        |a| {
          id: a["_id"]["id"],
          type: map_type(a),
          last_reading_at: map_time_instant(a),
          position: map_position(a),
          provider: a["_id"]["id"].split(':')[-2],
        }
      }

      return @assets.map {
        |a| {
          id: a[:id],
          type: a[:type],
          context: map_context(a),
          related: map_related(a)
        }
      }
    end

    def map_type(a)
      a["_id"]["id"].split(':')[-3]
    end

    def map_context(a)
      {
        service: a[:type],
        provider: a[:provider],
        group: nil,
        name: a[:id],
        last_reading_at: a[:last_reading_at],
        position: expand_position(a)
      }
    end

    def map_related(a)
      {
        service: a[:type],
        provider: a[:provider],
        group: nil,
        site: map_site(a),
      }
    end

    def map_site(a)
      if a[:position] and a[:position] != "null" and a[:position][:city]
        {
          id: a[:position][:city][:attributes][:name].downcase,
          name: a[:position][:city][:attributes][:name],
          description: a[:position][:city][:attributes][:description],
          position: expand_position(a),
          links: links_object(a).to_json
        }
      end
    end

    def links_object(a)
      Hash[*a[:position][:city][:links].map { |link|  [link[:relationship], { href: link[:url] } ] }.flatten]
    end

    def expand_position(a)
      logger.info a
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
      if a["attrs"]["position"]
        {
          latitude: a["attrs"]["position"]["value"].split(',')[0],
          longitude: a["attrs"]["position"]["value"].split(',')[1],
          city: City.where(name: "#{a["_id"]["id"].split(':')[3].capitalize}").includes(:links).map { |c| {attributes: c, links: c.links} }.first
        }
      else
        "null"
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
