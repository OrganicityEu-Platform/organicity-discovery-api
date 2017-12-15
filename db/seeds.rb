santander = City.find_or_create_by!(
  id: 1,
  name: 'Santander',
  description: 'The port city of Santander is the capital of the autonomous community and historical region of Cantabria situated on the north coast of Spain. Located east of Gijón and west of Bilbao, the city has a population of 178,465.',
  latitude: 43.45487,
  longitude: -3.81289,
  lonlat: 'POINT(-3.81289 43.45487)',
  country_code: 'ES',
  country: 'Spain',
  region: 'Cantabria'
)

london = City.find_or_create_by!(
  id: 2,
  name: 'London',
  description: 'London is the capital and most populous city of England and the United Kingdom.',
  latitude: 51.507222,
  longitude: -0.1275,
  lonlat: 'POINT(-0.1275 51.507222)',
  country_code: 'UK',
  country: 'United Kingdom',
  region: 'England'
)

aarhus = City.find_or_create_by!(
  id: 3,
  name: 'Aarhus',
  description: 'Aarhus is the second-largest city in Denmark and the seat of Aarhus Municipality.',
  latitude: 56.1572,
  longitude: 10.2107,
  lonlat: 'POINT(10.2107 56.1572)',
  country_code: 'DK',
  country: 'Denmark',
  region: 'East Jutland'
)

patras = City.find_or_create_by!(
  id: 4,
  name: 'Patras',
  description: 'Patras (or Patra) is Greece\'s third largest city and the regional capital of Western Greece, in northern Peloponnese, 215 km (134 mi) west of Athens. The city is built at the foothills of Mount Panachaikon, overlooking the Gulf of Patras.',
  latitude: 38.25,
  longitude: 21.733333,
  lonlat: 'POINT(21.733333 38.25)',
  country_code: 'GR',
  country: 'Greece',
  region: 'Western Greece'
)

leuven = City.find_or_create_by!(
  id: 5,
  name: 'Leuven',
  description: 'Leuven',
  latitude: 38.25,
  longitude: 21.733333,
  lonlat: 'POINT(21.733333 38.25)',
  country_code: 'GR',
  country: 'Greece',
  region: 'Western Greece'
)


santander.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/Santander,_Spain',
  relationship: 'wiki'
)

santander.links.find_or_create_by!(
  url: 'http://www.smartsantander.eu/',
  relationship: 'related'
)

london.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/London',
  relationship: 'wiki'
)

aarhus.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/Aarhus',
  relationship: 'wiki'
)

patras.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/Patras',
  relationship: 'wiki'
)

leuven.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/Patras',
  relationship: 'wiki'
)
