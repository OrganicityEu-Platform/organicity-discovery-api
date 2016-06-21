class AssetSerializer < ActiveModel::Serializer
  attributes :id, :type, :context, :related

  def id
    object[:id]
  end

  def type
    object[:id].split(':')[-3]
  end

  def provider
    {
      type: object[:id].split(':')[-2]
    }
  end

  def context
    {
      service: type,
      provider: object[:id].split(':')[-2],
      group: nil,
      name: id,
      last_reading_at: object[:last_reading_at],
      position: position
    }
  end

  def position
    if object[:position] and object[:position][:city]
      {
        latitude: object[:position][:latitude],
        longitude: object[:position][:longitude],
        city: object[:position][:city][:attributes][:name],
        region: object[:position][:city][:attributes][:region],
        country_code: object[:position][:city][:attributes][:country_code],
        country: object[:position][:city][:attributes][:country],
      }
    end
  end

  def related
    {
      service: service,
      provider: provider,
      group: group,
      site: site,
    }
  end

  def site
    if object[:position] and object[:position][:city]
      {
        id: object[:position][:city][:attributes][:name].downcase,
        name: object[:position][:city][:attributes][:name],
        description: object[:position][:city][:attributes][:description],
        position: position,
        links: links_object
      }
    end
  end

  def links_object
    Hash[*object[:position][:city][:links].map { |link|  [link[:relationship], { href: link[:url] } ] }.flatten]
  end

  def service
    {
      type: type
    }
  end

  def group
    {
        type: nil
    }
  end
end
