require "test_helper"

class LikeTest < ActiveSupport::TestCase
  test "valid like" do
    assert likes(:one).valid?
  end

  test "user can only like once per likeable" do
    duplicate = Like.new(user: users(:bob), likeable: gossips(:one))
    assert_not duplicate.valid?
  end

  test "different users can like same gossip" do
    like = Like.new(user: users(:alice), likeable: gossips(:one))
    assert like.valid?
  end

  test "belongs to user" do
    assert_equal users(:bob), likes(:one).user
  end

  test "belongs to likeable (gossip)" do
    assert_equal gossips(:one), likes(:one).likeable
  end
end
