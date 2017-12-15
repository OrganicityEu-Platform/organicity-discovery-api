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
  latitude: 50.879472,
  longitude: 4.701072,
  lonlat: 'POINT(4.701072 50.879472)',
  country_code: 'BE',
  country: 'Belgium',
  region: 'Vlaams Brabant'
)

edinburgh = City.find_or_create_by!(
  id: 6,
  name: 'Edinburgh',
  description: 'Edinburgh',
  latitude: 55.9327,
  longitude:  -2.9814,
  lonlat: 'POINT(-2.9814 55.9327)',
  country_code: 'UK',
  country: 'United Kingdom',
  region: ''
)

lisbon = City.find_or_create_by!(
  id: 7,
  name: 'Lisbon',
  description: 'Lisbon',
  latitude: 38.714006,
  longitude: -9.133467,
  lonlat: 'POINT(-9.133467 38.714006)',
  country_code: 'PT',
  country: 'Portugal',
  region: 'Regiao de Lisboa/ Lisboa'
)

novisad = City.find_or_create_by!(
  id: 8,
  name: 'Novisad',
  description: 'Novisad',
  latitude: 45.267136,
  longitude: 19.833549,
  lonlat: 'POINT(19.833549 45.267136)',
  country_code: 'RS',
  country: 'Serbia',
  region: 'Serbia'
)

ldieztest = City.find_or_create_by!(
  id: 8,
  name: 'LdiezTest',
  description: 'LdiezTest',
  latitude: 43.45487,
  longitude: -3.81289,
  lonlat: 'POINT(-3.81289 43.45487)',
  country_code: 'ES',
  country: 'Spain',
  region: 'Cantabria'
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
  url: 'https://en.wikipedia.org/wiki/Leuven',
  relationship: 'wiki'
)

edinburgh.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/Leuven',
  relationship: 'wiki'
)

lisbon.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/Leuven',
  relationship: 'wiki'
)

novisad.links.find_or_create_by!(
  url: 'https://en.wikipedia.org/wiki/Leuven',
  relationship: 'wiki'
)

ldieztest.links.find_or_create_by!(
  url: 'https://www.unican.es',
  relationship: 'wiki'
)
