require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "valid tag" do
    assert tags(:humour).valid?
  end

  test "invalid without title" do
    tag = Tag.new
    assert_not tag.valid?
  end

  test "title must be unique" do
    duplicate = Tag.new(title: tags(:humour).title)
    assert_not duplicate.valid?
  end

  test "has many gossips through join table" do
    assert_includes tags(:humour).gossips, gossips(:one)
  end
end
