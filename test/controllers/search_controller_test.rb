require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "search page is accessible" do
    get search_url
    assert_response :success
  end

  test "search with query returns results" do
    get search_url, params: { q: "Scoop" }
    assert_response :success
  end

  test "search finds gossip by title" do
    get search_url, params: { q: gossips(:one).title }
    assert_response :success
    assert_select "strong", text: gossips(:one).title
  end

  test "search finds user by first_name" do
    get search_url, params: { q: users(:alice).first_name }
    assert_response :success
  end

  test "search finds tag by title" do
    get search_url, params: { q: tags(:humour).title }
    assert_response :success
  end

  test "search with empty query shows no results" do
    get search_url, params: { q: "" }
    assert_response :success
  end
end
