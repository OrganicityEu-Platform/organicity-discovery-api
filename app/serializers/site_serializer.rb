class SiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :position, :links

  def position
    {
      latitude: object[:latitude],
      longitude: object[:longitude],
      city: object[:name],
      region: object[:region],
      country_code: object[:country_code],
      country: object[:country]
    }
  end

end
