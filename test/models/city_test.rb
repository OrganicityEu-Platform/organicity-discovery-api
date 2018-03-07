require 'test_helper'

class CityTest < ActiveSupport::TestCase
  #byebug
  santander = City.first
  london = City.second

  test "should match city name" do
    assert_equal 'Santander', santander.name
    assert_equal 'London', london.name
  end

  test "should have coordinates" do
    assert_same 43.45487, santander.latitude
    assert_same -3.81289, santander.longitude
  end
end
