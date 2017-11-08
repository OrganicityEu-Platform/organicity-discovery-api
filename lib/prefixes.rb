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

    pref_log = Logger.new('log/prefixes.log')
    pref_log.level = Logger::INFO

    #TODO: Use ENV variable for this URL
    # ENV['EXPERIMENTERS_PREFIX_URL']
    url = 'https://experimenters.organicity.eu:8443/emscheck/experiments-prefixes'

    pref_log.info '-------'

    # Logged in users (with authheader) use a different cache
    if authheader == nil
      pref_log.info "authheader nil"
      call = RestCall.find(url: url, token: '').sort(by: :created_at).last
    else
      pref_log.info "authheader received"
      call = RestCall.find(url: url, token: authheader).sort(by: :created_at).last
    end

    p '---'
    p RestCall.find(url: url, token: '').sort(by: :created_at).first.created_at
    p RestCall.find(url: url, token: '').sort(by: :created_at).last.created_at

    if call
      pref_log.info "Time now: #{Time.now}"
      pref_log.info "LastCall: #{call.created_at.to_time + 300.seconds}"
      pref_log.info "New cache after: #{call.created_at.to_time + 300.seconds - Time.now}"
      pref_log.info "Cache age      : #{Time.now - call.created_at.to_time}"
      pref_log.info RestCall.find(url: url, token: '').sort(by: :created_at).count
    end

    # Cache it
    if call.nil? or ( Time.now > Time.parse(call.created_at) + 300.seconds )
      pref_log.info 'NEW CACHE'

      begin
        resp = HTTP.timeout(:read => 5).auth(authheader).get(url)
      rescue
        pref_log.info "---- Rescue! HTTP Timeout?"
        return
      end

      if resp
        pref_log.info "Response code from experimenters API: #{resp.code}"
        if resp.code == 200
          prefixes = JSON.parse(resp.to_s)["allowed_prefixes"]
        end
      else
        # TODO: If there is a problem with experimenters API, should we RETURN with no prefixes or do something else?
        return
      end

      if authheader == nil
        # NOTE: This call saves the correct time, but we are unable to find it below!
        created_call = RestCall.create(url: url, token: '', created_at: Time.now, response: prefixes)
        p created_call.created_at
      else
        created_call = RestCall.create(url: url, token: authheader, created_at: Time.now, response: prefixes)
      end

      # DEBUG: Print all in redis, + id + date + response.length
      # RestCall.find(url: url, token: '').sort(by: :created_at).each do |f|; puts "#{f.id}\t #{f.created_at} #{f.response.length}"; end

      # INCORRECT time
      # p RestCall.find(url: url, token: '').sort(by: :created_at).last.created_at

      # CORRECT time
      # p created_call.created_at

    else
      pref_log.info "Using cache."
      # the call we found earlier
      created_call = call
    end

    #FIXME: Redis returns prefixes as a String, (but this method should always return an Array)
    # So anytime the cache is used, it needs to JSON.parse
    if created_call.response.is_a? String
      return JSON.parse created_call.response
    end

    return created_call.response
  end


end
