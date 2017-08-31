require 'test_helper'

class BlogFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # OPTIMIZE: These are just basic tests to see if our calls work

  test 'get 200 on /v0/assets' do
    get '/v0/assets'
    assert_response :success
  end

  test 'get 200 on /v0/assets/ngsiv2' do
    get '/v0/assets/ngsiv2'
    assert_response :success
  end

  test 'get 200 on /v0/assets/sites' do
    get '/v0/assets/sites'
    assert_response :success
  end

  test 'get 200 on /v0/assets/sites/id' do
    get '/v0/assets/sites/1'
    assert_response :success
  end

  test 'get 200 on /v0/assets/experiments' do
    get '/v0/assets/experiments'
    assert_response :success
  end

  test 'get 200 on /v0/assets/experimenters' do
    get '/v0/assets/experimenters'
    assert_response :success
  end

  test 'get 200 on /v0/assets/geo' do
    get '/v0/assets/geo'
    assert_response :success
  end

  test 'get 200 on /v0/assets/geo/search' do
    get '/v0/assets/geo/search'
    assert_response :success
  end

  test 'get 200 on /v0/assets/metadata' do
    get '/v0/assets/metadata'
    assert_response :success
  end

  test 'get 200 on /v0/assets/metadata/search' do
    get '/v0/assets/metadata/search'
    assert_response :success
  end

  test 'get 200 on /v0/assets/providers' do
    get '/v0/assets/providers'
    assert_response :success
  end

  test 'get 200 on /v0/assets/services' do
    get '/v0/assets/services'
    assert_response :success
  end

  test 'get 200 on /v0/types' do
    get '/v0/types'
    assert_response :success
  end

  # assets/:id
  test 'get 200 on /v0/assets/:id' do
    get '/v0/assets/urn:oc:entity:london:transportService:TransportAPI:NEH'
    assert_response :success
  end

  test 'get 200 on /v0/assets/:id/data' do
    get '/v0/assets/urn:oc:entity:london:transportService:TransportAPI:NEH/data'
    assert_response :success
  end

  test 'get 200 on /v0/assets/:id/nearby' do
    get '/v0/assets/urn:oc:entity:london:transportService:TransportAPI:NEH/nearby'
    assert_response :success
  end

  test 'get 200 on /v0/assets/:id/ngsiv2' do
    get '/v0/assets/urn:oc:entity:london:transportService:TransportAPI:NEH/ngsiv2'
    assert_response :success
  end

end
