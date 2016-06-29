class SiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :position, :links

  def position
    {
      latitude: object[:latitude].to_f,
      longitude: object[:longitude].to_f,
      city: object[:name],
      region: object[:region],
      country_code: object[:country_code],
      country: object[:country]
    }
  end

  def links
    Hash[*object.links.map { |link|  [link[:relationship], { href: link[:url] } ] }.flatten]
  end

end
