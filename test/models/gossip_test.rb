require "test_helper"

class GossipTest < ActiveSupport::TestCase
  test "valid gossip" do
    assert gossips(:one).valid?
  end

  test "invalid without title" do
    gossip = Gossip.new(content: "Some content", user: users(:alice))
    assert_not gossip.valid?
  end

  test "title must be between 3 and 14 characters" do
    gossip = Gossip.new(title: "ab", content: "Content", user: users(:alice))
    assert_not gossip.valid?

    gossip.title = "a" * 15
    assert_not gossip.valid?

    gossip.title = "Valid"
    assert gossip.valid?
  end

  test "invalid without content" do
    gossip = Gossip.new(title: "Valid", user: users(:alice))
    assert_not gossip.valid?
  end

  test "belongs to user" do
    assert_equal users(:alice), gossips(:one).user
  end

  test "has many tags through join table" do
    assert_includes gossips(:one).tags, tags(:humour)
  end

  test "has many comments" do
    assert_includes gossips(:one).comments, comments(:one)
  end

  test "has many likes" do
    assert_includes gossips(:one).likes, likes(:one)
  end
end
