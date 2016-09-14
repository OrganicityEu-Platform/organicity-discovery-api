class City < ApplicationRecord
  has_many :links, as: :linkable

  scope :nearby, -> (longitude, latitude, distance_in_meters = 2000) {
    lonlat = "POINT(#{longitude} #{latitude})"
    order("ST_Distance(lonlat, ST_GeomFromText('#{lonlat}',4326))").limit(1)
  }
end
