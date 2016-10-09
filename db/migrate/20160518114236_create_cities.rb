class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string            :name
      t.string            :country
      t.string            :country_code
      t.string            :region
      t.string            :avatar_src
      t.string            :header_image_src
      t.text              :description
      t.float             :latitude
      t.float             :longitude
      t.st_point          :lonlat, geographic: true
      t.timestamps
    end
  end
end
