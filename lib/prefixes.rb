module Prefixes

  # 1. For each request with a valid token we need a new class that will be triggered and will do the following:
  #   - Check if the TOKEN prefixes are cached
  #   - Use the token to do a GET request against the Authentication Services
  #   - At the moment this will be just the Experimenters Portal
  #   - This will return a list of prefixes for this specific TOKEN (sub)

  # 2. We will use this prefixes on all the requests to mongo in (orion_mongo_client)
  #  - We will use the list of prefixes using wildcards and with an OR clause against the urn property of
  #    each asset, that will be added with an AND clause to all the request we do:
  #
  #   Mongo queries with and without regex:
  #   db.entities.find({"_id.id": {'$regex': "urn:oc:entity:experimenters:XXX"}})
  #   db.entities.find({"_id.id":/^urn:oc:entity:experimenters:/})
  #   Searching multiple values:
  #   db.entities.find({"_id.id":{ $in: [/bf148025-0ba7-4635-8c09-23d7a4495412:582c/, /b23/] }})

  def isTokenPrefixCached
    puts "------ Check if token prefixes are cached --------"
    return true
  end

  def getPrefixes(authheader = nil)
    #TODO: Use ENV variable for this URL
    url = 'https://experimenters.organicity.eu:8443/emscheck/experiments-prefixes'

    # Cache it
    call = RestCall.find(url: url, token: authheader).sort(by: :created_at)
    # TODO: time= 300 sec
    if call.empty? or ( Time.now > Time.parse(call.last.created_at) + 300.seconds )
      resp = HTTP.timeout(:read => 5).auth(authheader).get(url)
      prefixes = JSON.parse(resp.to_s)["allowed_prefixes"]
      @cached_call = RestCall.create(url: url, token: authheader, created_at: Time.now, response: prefixes)
    else
      call = call.last
      @cached_call = call
    end

    #FIXME: Redis returns prefixes as a String, (but this method should always return an Array)
    # So anytime the cache is used, it needs to JSON.parse
    if @cached_call.response.is_a? String
      return JSON.parse @cached_call.response
    end

    return @cached_call.response
  end


end
