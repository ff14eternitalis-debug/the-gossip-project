require "test_helper"

class PrivateMessageTest < ActiveSupport::TestCase
  test "valid message" do
    assert private_messages(:one).valid?
  end

  test "invalid without content" do
    msg = PrivateMessage.new(sender: users(:alice))
    assert_not msg.valid?
  end

  test "belongs to sender" do
    assert_equal users(:alice), private_messages(:one).sender
  end

  test "has recipients" do
    assert_includes private_messages(:one).recipients, users(:bob)
  end

  test "user has sent_messages" do
    assert_includes users(:alice).sent_messages, private_messages(:one)
  end

  test "user has received_messages" do
    assert_includes users(:bob).received_messages, private_messages(:one)
  end
end
