require 'net/http'
require 'json'
require 'openssl'
require 'base64'
include Mongo

module MongoOrionClient
  MONGO_URL = Rails.application.secrets.mongo_url
  MONGO_PORT = Rails.application.secrets.mongo_port

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
          '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], params[:radius].to_i ] }
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

  def query_mongo_service_entities(params)
    log params
    orion = setup_client
    orion[:entities].find(
      {
        '_id.type' => /.*#{params[:service]}.*/,
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

  def query_mongo_entity(params)
    log params
    orion = setup_client
    orion[:entities].find(
      {
        '_id.id' => /#{params[:id]}/,
      },
      {
        :limit => 1
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
