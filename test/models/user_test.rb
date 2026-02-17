require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    assert users(:alice).valid?
  end

  test "invalid without email" do
    user = User.new(first_name: "Test", encrypted_password: "x")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "email must be unique" do
    duplicate = User.new(email: users(:alice).email, password: "password123")
    assert_not duplicate.valid?
  end

  test "age must be positive" do
    user = users(:alice)
    user.age = -1
    assert_not user.valid?
  end

  test "has many gossips" do
    assert_respond_to users(:alice), :gossips
  end

  test "has many comments" do
    assert_respond_to users(:alice), :comments
  end

  test "has many likes" do
    assert_respond_to users(:alice), :likes
  end

  test "has many sent_messages" do
    assert_respond_to users(:alice), :sent_messages
  end

  test "has many received_messages" do
    assert_respond_to users(:bob), :received_messages
  end

  test "city is optional" do
    user = User.new(email: "no_city@example.com", password: "password123")
    user.city = nil
    assert user.valid?
  end
end
