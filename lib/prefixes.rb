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

    # Logged in users (with authheader) use a different cache
    pref_log.info "#{url}/#{authheader}"

    Rails.cache.fetch("#{url}/#{authheader}", expires_in: 200.seconds) do
      pref_log.info 'NEW CACHE'
      #API CALL
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
    end

  end
end
