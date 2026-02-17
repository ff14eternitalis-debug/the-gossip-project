require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @gossip = gossips(:one)
    @like = likes(:one)
  end

  test "create like when signed in" do
    sign_in @alice
    assert_difference "Like.count", 1 do
      post likes_url, params: { likeable_type: "Gossip", likeable_id: @gossip.id }
    end
  end

  test "create redirects when not signed in" do
    post likes_url, params: { likeable_type: "Gossip", likeable_id: @gossip.id }
    assert_response :redirect
  end

  test "destroy like as owner" do
    sign_in @bob
    assert_difference "Like.count", -1 do
      delete like_url(@like)
    end
  end

  test "create rejects invalid likeable type" do
    sign_in @alice
    assert_no_difference "Like.count" do
      post likes_url, params: { likeable_type: "User", likeable_id: @alice.id }
    end
  end
end
