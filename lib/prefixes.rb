module Prefixes

# 1. For each request with a valid token we need a new class that will be triggered and will do the following:
#   - Check if the TOKEN prefixes are cached
#   - Use the token to do a GET request against the Authentication Services
#   - At the moment this will be just the Experimenters Portal
#   - This will return a list of prefixes for this specific TOKEN (sub)
# 2. We will use this prefixes on all the request to mongo in (orion_mongo_client)
#   - We will use the list of prefixes using  wildcards and with an OR clause against the urn property of each asset, that will be added with an AND clause to all the request we do:


  def isTokenPrefixCached
    puts "------ Token is cached --------"
    return true
  end

  def getPrefixes
    prefixes = ['some test prefixes']
    # curl -X GET \
    #  https://experimenters.organicity.eu:8443/emscheck/experiments-prefixes \
    #  -H 'authorization: Bearer eyJhbGciOiJSUzI1NiJ9.sfd.asdf' \
    #  -H 'cache-control: no-cache' \
    #  -H 'postman-token: 27dd01ff-0969-3114-9638-c87100bb4bf4'

    @client = HTTPClient.new
    url = 'https://experimenters.organicity.eu:8443/emscheck/experiments-prefixes'
    token = '12345XXXXXXXXXXXXXXXXXXXXXXXXXXX'
    headers = {
      'authorization' => "Bearer #{token}",
      'cache-control' => 'no-cache',
    }
    #puts headers

    response = @client.get(url, nil,  headers)

    puts "=="
    p response.status
    p response.contenttype
    p response.content
    puts "=="

    puts response.inspect

    prefixes = JSON.parse(response.body)["allowed_prefixes"]

    return prefixes
  end


end
