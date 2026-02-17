require "test_helper"

class GossipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @gossip = gossips(:one)
  end

  # --- Index ---
  test "index is accessible" do
    get gossips_url
    assert_response :success
  end

  # --- Show ---
  test "show displays gossip" do
    get gossip_url(@gossip)
    assert_response :success
  end

  test "show returns 404 for unknown gossip" do
    get gossip_url(id: 999_999)
    assert_response :not_found
  end

  # --- New / Create ---
  test "new redirects when not signed in" do
    get new_gossip_url
    assert_response :redirect
  end

  test "new is accessible when signed in" do
    sign_in @alice
    get new_gossip_url
    assert_response :success
  end

  test "create gossip when signed in" do
    sign_in @alice
    assert_difference "Gossip.count", 1 do
      post gossips_url, params: { gossip: { title: "NewOne", content: "Content here" } }
    end
    assert_redirected_to gossip_url(Gossip.last)
  end

  test "create with invalid data renders new" do
    sign_in @alice
    assert_no_difference "Gossip.count" do
      post gossips_url, params: { gossip: { title: "", content: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- Edit / Update ---
  test "edit redirects when not signed in" do
    get edit_gossip_url(@gossip)
    assert_response :redirect
  end

  test "edit is accessible for author" do
    sign_in @alice
    get edit_gossip_url(@gossip)
    assert_response :success
  end

  test "edit redirects non-author" do
    sign_in @bob
    get edit_gossip_url(@gossip)
    assert_redirected_to gossip_url(@gossip)
  end

  test "update gossip as author" do
    sign_in @alice
    patch gossip_url(@gossip), params: { gossip: { title: "Updated" } }
    assert_redirected_to gossip_url(@gossip)
    @gossip.reload
    assert_equal "Updated", @gossip.title
  end

  # --- Destroy ---
  test "destroy gossip as author" do
    sign_in @alice
    assert_difference "Gossip.count", -1 do
      delete gossip_url(@gossip)
    end
    assert_redirected_to gossips_url
  end

  test "destroy redirects non-author" do
    sign_in @bob
    assert_no_difference "Gossip.count" do
      delete gossip_url(@gossip)
    end
    assert_redirected_to gossip_url(@gossip)
  end
end
