require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "valid comment" do
    assert comments(:one).valid?
  end

  test "invalid without content" do
    comment = Comment.new(user: users(:alice), commentable: gossips(:one))
    assert_not comment.valid?
  end

  test "belongs to user" do
    assert_equal users(:bob), comments(:one).user
  end

  test "belongs to commentable (gossip)" do
    assert_equal gossips(:one), comments(:one).commentable
  end

  test "can have nested comments" do
    reply = Comment.new(content: "Reply", user: users(:alice), commentable: comments(:one))
    assert reply.valid?
  end

  test "destroying gossip destroys comments" do
    gossip = gossips(:one)
    assert_difference "Comment.count", -1 do
      gossip.destroy
    end
  end
end
