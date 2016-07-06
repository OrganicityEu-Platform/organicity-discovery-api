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

  def mongo_geo_search_assets(params)
    orion = setup_client
    orion[:entities].find(
      {
        'location.coords.coordinates' => {
          '$geoWithin': { '$center': [
            [  params[:long].to_f, params[:lat].to_f ],
            params[:radius].to_i
          ] }
        }
      },
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => sort_query(params)
      }
    ).to_a
  end

  def mongo_site_assets(params)
    orion = setup_client
    orion[:entities].find(
      {
        '_id.id' => /.*#{params[:site]}.*/,
      },
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => sort_query(params)
      }
    ).to_a
  end

  def mongo_provider_assets(params)
    orion = setup_client
    orion[:entities].find(
      {
        '_id.id' => /.*#{params[:provider]}.*/,
      },
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => sort_query(params)
      }
    ).to_a

  end

  def mongo_service_assets(params)
    orion = setup_client
    orion[:entities].find(
      {
        '_id.id' => /.*#{params[:service]}.*/,
      },
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => sort_query(params)
      }
    ).to_a

  end

  def mongo_geo_assets(params)
    log params
    orion = setup_client
    orion[:entities].find({}).to_a
  end

  def mongo_assets(params)
    log params
    orion = setup_client
    orion[:entities].find(
      # '_id.id' => /.*#{params[:site]}.*/ || /.*#{params[:provider]}.*/
      # '_id.type' => /.*#{params[:service]}.*/,
      # 'location.coords.coordinates' => {
      #   '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], params[:radius].to_i ] }
      # }
      # Search metadata and attributes:
      # 'attr.#{attr_name}' => /.*#{value}.*/
      {},
      {
        :skip => offset(params),
        :limit => limit(params),
        :sort => sort_query(params)
      }
    ).to_a
  end

  def mongo_asset(params)
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

  def send_logs(logs)
    orion = setup_client
    # send logs to mongo
  end

  def order_query(params)
    if params[:order]
      return params[:order]
    else
      return 'ASC'
    end
  end

  def sort_query(params)
    if params[:sort]
      return params[:sort]
    else
      return 'attrs.TimeInstant.value'
    end
  end

  def limit(params)
    return params[:per].to_i
  end

  def offset(params)
    return (params[:page].to_i - 1) * params[:per].to_i
  end
end
