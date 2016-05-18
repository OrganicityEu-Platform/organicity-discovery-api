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
