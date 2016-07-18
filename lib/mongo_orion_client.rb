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

  def create_options(params)
    mbuilder = {}
    o = offset(params)
    l = limit(params)
    s = sort_query(params)

    mbuilder.merge!(:skip => o) if o

    mbuilder.merge!(:limit => l) if l

    mbuilder.merge!(:sort => s) if s

    return mbuilder
  end

  def create_query(params)
    qbuilder = { '_id.id' => /.*#{params[:site] ? params[:site] : ''}.#{params[:service] ? params[:service] : '*'}.#{params[:provider] ? params[:provider] : '*'}.#{params[:group] ? params[:group] : '*'}.*/ }

    if params[:long] and params[:lat] and params[:radius]
      qbuilder.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], "#{params[:radius] ? params[:radius] : 1}".to_i ] }
      })
    end

    if params[:type]
      qbuilder.merge!("_id.type" => /.*#{params[:type]}.*/)
    end

    if paramas[:q]
      qbuilder.merge!({ "attrNames": params[:q] })
    end

    return qbuilder
  end

  def mongo_geo_assets(params)
    log params
    orion = setup_client
    orion[:entities].find({}).to_a
  end

  def mongo_assets(params)
    logger.warn params
    orion = setup_client
    q = create_query(params)
    m = create_options(params)
    logger.warn q
    logger.warn m
    orion[:entities].find(
      q,
      m
    ).to_a
  end

  def mongo_data_asset(params)
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
    return params[:per].to_i unless params[:per].blank?
  end

  def offset(params)
    return (params[:page].to_i - 1) * params[:per].to_i unless params[:page].blank?
  end
end
