require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @gossip = gossips(:one)
    @comment = comments(:one)
  end

  test "create comment when signed in" do
    sign_in @alice
    assert_difference "Comment.count", 1 do
      post gossip_comments_url(@gossip), params: { comment: { content: "Nice!" } }
    end
    assert_redirected_to gossip_url(@gossip)
  end

  test "create redirects when not signed in" do
    post gossip_comments_url(@gossip), params: { comment: { content: "Nice!" } }
    assert_response :redirect
  end

  test "edit accessible for comment author" do
    sign_in @bob
    get edit_comment_url(@comment)
    assert_response :success
  end

  test "edit redirects non-author" do
    sign_in @alice
    get edit_comment_url(@comment)
    assert_response :redirect
  end

  test "update comment as author" do
    sign_in @bob
    patch comment_url(@comment), params: { comment: { content: "Updated" } }
    assert_redirected_to gossip_url(@gossip)
    @comment.reload
    assert_equal "Updated", @comment.content
  end

  test "destroy comment as author" do
    sign_in @bob
    assert_difference "Comment.count", -1 do
      delete comment_url(@comment)
    end
    assert_redirected_to gossip_url(@gossip)
  end
end
