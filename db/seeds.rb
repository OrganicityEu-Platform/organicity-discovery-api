# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
City.create!(
  name: 'Santander',
  description: 'The port city of Santander is the capital of the autonomous community and historical region of Cantabria situated on the north coast of Spain. Located east of Gijón and west of Bilbao, the city has a population of 178,465.',
  latitude: 43.45487,
  longitude: -3.81289,
  country_code: 'ES',
  country: 'Spain',
  region: 'Cantabria'
)

City.create!(
  name: 'London',
  description: 'London is the capital and most populous city of England and the United Kingdom.',
  latitude: 51.507222,
  longitude: -0.1275,
  country_code: 'UK',
  country: 'United Kingdom',
  region: 'England'
)

City.create!(
  name: 'Aarhus',
  description: 'Aarhus is the second-largest city in Denmark and the seat of Aarhus Municipality.',
  latitude: 56.1572,
  longitude: 10.2107,
  country_code: 'DK',
  country: 'Denmark',
  region: 'East Jutland'
)
