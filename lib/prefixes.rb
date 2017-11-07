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

  def get_prefixes(authheader = nil)
    #TODO: Use ENV variable for this URL
    # ENV['EXPERIMENTERS_PREFIX_URL']
    url = 'https://experimenters.organicity.eu:8443/emscheck/experiments-prefixes'

    # Logged in users (with authheader) use a different cache
    if authheader == nil
      call = RestCall.find(url: url).sort(by: :created_at)
      #NOTE: call.last was nil according to Sentry - remove those logger.warn?
      #logger.warn "Time since last cache (non user): #{Time.now - call.last.created_at.to_time}"
    else
      call = RestCall.find(url: url, token: authheader).sort(by: :created_at)
      #logger.warn "Time since last cache (logged in user):  #{Time.now - call.last.created_at.to_time}"
    end

    # Cache it
    if call.empty? or ( Time.now > Time.parse(call.last.created_at) + 300.seconds )
      logger.warn "New cache"

      begin
        resp = HTTP.timeout(:read => 5).auth(authheader).get(url)
      rescue
        logger.warn "Rescue"
        return
      end

      if resp
        logger.warn "Response code from experimenters API: #{resp.code}"
        if resp.code == 200
          prefixes = JSON.parse(resp.to_s)["allowed_prefixes"]
        end
      else
        # TODO: If there is a problem with experimenters API, should we RETURN with no prefixes or do something else?
        return
      end

      @cached_call = RestCall.create(url: url, token: authheader, created_at: Time.now, response: prefixes)
    else
      logger.warn "Using cache."
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
