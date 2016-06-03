require 'net/http'
require 'json'
require 'openssl'
require 'base64'
include Mongo

module MongoOrionClient
  MONGO_URL = "localhost"
  MONGO_PORT = "4433"

  def setup_client
    mongo_client = MongoClient.new(MONGO_URL, MONGO_PORT)
    mongo_client.db('orion')
  end

  def query_mongo_geo_search(params)
    log params
    orion = setup_client
    orion[:entities].find(
      {
        'location.coords.coordinates' => {
          '$geoWithin': { '$center': [ [ params[:lat].to_f, params[:long].to_f ] , params[:radius].to_i ] }
        }
      },
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => 'attrs.TimeInstant.value'
      }
    ).to_a
  end

  def query_mongo_site_entities(params)
    log params
    orion = setup_client
    orion[:entities].find(
      {
        '_id.id' => /.*#{params[:site]}.*/,
      },
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => 'attrs.TimeInstant.value'
      }
    ).to_a

  end

  def query_mongo_entities(params)
    log params
    orion = setup_client
    orion[:entities].find(
      {},
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => 'attrs.TimeInstant.value'
      }
    ).to_a
  end

  def limit(params)
    return params[:per].to_i
  end

  def offset(params)
    return (params[:page].to_i - 1) * params[:per].to_i
  end
end
