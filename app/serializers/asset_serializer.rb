class AssetSerializer < ActiveModel::Serializer
  attributes :id, :type, :context, :related

  def id
    object[:id].split(':')[-1]
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
    {
      latitude: object[:position][:latitude],
      longitude: object[:position][:longitude],
      city: object[:position][:city][:name],
      country_code: object[:position][:city][:country_code],
      country: object[:position][:city][:country]
    }
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
    object[:position][:city]
    \
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
