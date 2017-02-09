require 'net/http'
require 'json'
require 'openssl'
require 'base64'
include Mongo

module MongoOrionClient
  MONGO_URL = Rails.application.secrets.mongo_url
  MONGO_PORT = Rails.application.secrets.mongo_port

  def setup_client
    @mongo_client = MongoClient.new(MONGO_URL, MONGO_PORT)
    @mongo_client.db('orion-organicity')
  end

  def mongo_orion_logger(request, session)
    if (Rails.configuration.api_log) 
      @mongo_client = MongoClient.new(MONGO_URL, MONGO_PORT)
      apilog = @mongo_client.db('apilog')
      doc = {
        timestamp: Time.now.to_time.iso8601,
        ip: request.remote_ip,
        session: session,
        service: "AssetsDiscovery",
        method: "assets",
        url: request.env["REQUEST_URI"]
      }
      apilog[:apiLogEntry].insert(doc)
    end
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

# Experimenters: {"_id.id": /urn:oc:entity:experimenters:62afc265-af9a-47e7-afb5-caab21ed09b4/}
# Experiments: {"_id.id": /urn:oc:entity:experimenters:[^:]+:57f3debd6ec783244b3901e2/}

  def search_q(params)

    # This is temp to solve cache worker issue. Must change
    if (!params.is_a? Object) 
      params = {}
    end 
     
    if params[:experimenter] 
      return /urn:oc:entity:experimenters:#{params[:experimenter]}/
    elsif params[:experiment]
      return /urn:oc:entity:experimenters:[^:]+:#{params[:experiment]}/
    else
      return /.*#{params[:site] ? params[:site] : ''}.#{params[:service] ? params[:service] : '*'}.#{params[:provider] ? params[:provider] : '*'}.#{params[:group] ? params[:group] : '*'}.*/
    end
  end

  def create_query(params)
    qbuilder = { '_id.id' => search_q(params) }

    if params[:long] and params[:lat]
      if !params[:radius] 
        params[:radius] = 1
        params[:km]     = true;
      end  

      params[:radius] = params[:radius].to_f

      if params[:km] 
        params[:radius] = params[:radius] / 6378.1
      end

      qbuilder.merge!("location.coords.coordinates" => {
        #'$geoWithin': { '$centerSphere': [ [  params[:long].to_f, params[:lat].to_f ], params[:radius] ] }
        '$geoWithin': { '$centerSphere': [ [  params[:lat].to_f, params[:long].to_f ], params[:radius] ] }
      })
    end

    if params[:type]
      qbuilder.merge!("_id.type" => /.*#{params[:type]}.*/)
    end

    if params[:q]
      qbuilder.merge!({ "attrNames": params[:q] })
    end

    return qbuilder
  end

  # These methods should be merged
  def mongo_geo_search_assets(params)
    logger.warn params
    orion = setup_client
    q = create_query(params)
    m = create_options(params)
    orion[:entities].find(q,m).to_a
  end

  def mongo_geo_assets(params)
    logger.warn params
    orion = setup_client
    q = create_query(params)
    m = create_options(params)
    orion[:entities].find(q,m).to_a
  end

  def mongo_geo_count_assets(params)
    log params
    orion = setup_client
    q = {}
    if params[:zoom].to_i == 0
      q.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], 1] }
      })
    elsif params[:zoom].to_i == 1
      q.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], 10 ] }
      })
    elsif params[:zoom].to_i == 2
      q.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], 20 ] }
      })
    elsif params[:zoom].to_i == 3
      q.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], 30 ] }
      })
    elsif params[:zoom].to_i == 4
      q.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], 40 ] }
      })
    elsif params[:zoom].to_i == 5
      q.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], 50 ] }
      })
    else
      q.merge!("location.coords.coordinates" => {
        '$geoWithin': { '$center': [ [  params[:long].to_f, params[:lat].to_f ], 100 ] }
      })
    end
    m = create_options(params)
    logger.warn q
    logger.warn m
    orion[:entities].find(q,m).count
  end

  def mongo_metadata_search_assets(params)
    if Rails.configuration.orion_meta_index 
      mongo_metadata_search_assets_index(params)
    else
      mongo_metadata_search_assets_no_index(params)
    end
  end  

  def mongo_metadata_search_assets_index(params)
    orion = setup_client
    m = create_options(params)
    q = {
      '$text' => {
        '$search' => params[:query],
        '$language' => 'english'
      }
    }
    logger.warn q
    logger.warn m
    orion[:entities].find(q,m).to_a
  end

  def mongo_metadata_search_assets_no_index(params)
    q = {}
    if params[:query]
      queries = params[:query].split(' ')
      search_list = []
      if queries.length > 1
        search_list.push({ "_id.id": /^#{queries.map {|q| "(?=.*#{q})"}.join()}.*$/ })
        search_list.push({ "_id.type": /^#{queries.map {|q| "(?=.*#{q})"}.join()}.*$/ })
        queries.each do |query|
          search_list.push({ "attrNames": query })
        end
      else
        search_list.push({"_id.id" => /.*#{queries[0]}.*/}, {"_id.type" => /.*#{queries[0]}.*/}, { "attrNames": queries[0] })
      end
      q.merge!('$or' => search_list)
    end
    logger.warn params
    orion = setup_client
    m = create_options(params)
    logger.warn q
    logger.warn m
    orion[:entities].find(
      q,
      m
    ).to_a
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

  def mongo_asset_nearby(params)
    asset = mongo_asset(params).first
    params[:radius] = 10
    params[:km] = true

    if asset and asset["attrs"]["position"] and asset["attrs"]["position"]["type"] == "coords"
      params[:long] = asset["attrs"]["position"]["value"].split(',')[1]
      params[:lat]  = asset["attrs"]["position"]["value"].split(',')[0]
      logger.warn params
      return mongo_geo_assets(params)
    elsif asset and asset["attrs"]["location"]
      params[:long] = asset["attrs"]["location"]["value"].split(',')[0]
      params[:lat]  = asset["attrs"]["location"]["value"].split(',')[1]
      logger.warn params
      return mongo_geo_assets(params)
    elsif asset and asset["location"] and asset["location"]["coords"]
      params[:long] = asset["location"]["coords"]["coordinates"][1]
      params[:lat]  = asset["location"]["coords"]["coordinates"][0]
      logger.warn params
      return mongo_geo_assets(params)
    elsif asset and asset["attrs"]["latitude"] and asset["attrs"]["longitude"]
      params[:long] = asset["attrs"]["longitude"]["value"]
      params[:lat]  = asset["attrs"]["latitude"]["value"]
      logger.warn params
      return mongo_geo_assets(params)
    else
      return []
    end
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
