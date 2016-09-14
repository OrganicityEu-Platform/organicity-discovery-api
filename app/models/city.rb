class City < ApplicationRecord
  has_many :links, as: :linkable

  scope :close_to, -> (latitude, longitude, distance_in_meters = 2000) {
    lonlat = "POINT(#{longitude} #{latitude})"
    order("ST_Distance(lonlat, ST_GeomFromText('#{unit.lonlat.as_text}',4326))").limit(10)
  }
end
