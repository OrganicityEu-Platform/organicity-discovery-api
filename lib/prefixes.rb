module Prefixes

  # 1. For each request with a valid token we need a new class that will be triggered and will do the following:
  #   - Check if the TOKEN prefixes are cached
  #   - Use the token to do a GET request against the Authentication Services
  #   - At the moment this will be just the Experimenters Portal
  #   - This will return a list of prefixes for this specific TOKEN (sub)

  # 2. We will use this prefixes on all the requests to mongo in (orion_mongo_client)
  #   - We will use the list of prefixes using wildcards and with an OR clause against the urn property of
  #   each asset, that will be added with an AND clause to all the request we do:

  # curl -X GET \
  #  https://experimenters.organicity.eu:8443/emscheck/experiments-prefixes \
  #  -H 'authorization: Bearer eyJhbGciOiJSUzI1NiJ9.sfd.asdf' \
  #  -H 'cache-control: no-cache' \
  #  -H 'postman-token: 27dd01ff-0969-3114-9638-c87100bb4bf4'

  def isTokenPrefixCached
    puts "------ Check if token prefixes are cached --------"
    return true
  end

  def getPrefixes(authheader)
    prefixes = ['some test prefixes']

    #TODO: Use ENV variable for this URL
    url = 'https://experimenters.organicity.eu:8443/emscheck/experiments-prefixes'

    #TODO: do we need cache-control?
    response = HTTP.auth(authheader).get(url)
    #.headers(:cache-control => 'no-cache')

    prefixes = JSON.parse(response.to_s)["allowed_prefixes"]

    return prefixes
  end


end
