class AssetSerializer < ActiveModel::Serializer
  attributes :id, :type, :context, :related

  def id
    logger.warn object
    object[:id]
  end

  def type
    object[:type]
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
      last_updated_at: object[:last_updated_at],
      reputation: object[:reputation],
      position: position
    }
  end

  def position
    if object[:position] and not object[:position][:city].nil?
      {
        latitude: object[:position][:latitude].to_f,
        longitude: object[:position][:longitude].to_f,
        city: object[:position][:city][:attributes][:name],
        region: object[:position][:city][:attributes][:region],
        country_code: object[:position][:city][:attributes][:country_code],
        country: object[:position][:city][:attributes][:country],
      }
    elsif object[:position]
      {
        latitude: object[:position][:latitude].to_f,
        longitude: object[:position][:longitude].to_f
      }
    else
      nil
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
        position: [ object[:position][:city][:attributes][:longitude].to_f, object[:position][:city][:attributes][:latitude].to_f ],
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
