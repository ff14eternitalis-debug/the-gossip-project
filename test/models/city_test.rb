require "test_helper"

class CityTest < ActiveSupport::TestCase
  test "valid city" do
    city = cities(:paris)
    assert city.valid?
  end

  test "invalid without name" do
    city = City.new(zip_code: "75000")
    assert_not city.valid?
    assert_includes city.errors[:name], "can't be blank"
  end

  test "invalid without zip_code" do
    city = City.new(name: "Paris")
    assert_not city.valid?
    assert_includes city.errors[:zip_code], "can't be blank"
  end

  test "zip_code format must be digits or dashes" do
    city = City.new(name: "Test", zip_code: "abc")
    assert_not city.valid?
  end

  test "has many users" do
    assert_respond_to cities(:paris), :users
    assert_includes cities(:paris).users, users(:alice)
  end
end
