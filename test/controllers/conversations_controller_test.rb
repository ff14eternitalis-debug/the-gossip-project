require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @message = private_messages(:one)
  end

  # --- Index ---
  test "index redirects when not signed in" do
    get conversations_url
    assert_response :redirect
  end

  test "index accessible when signed in" do
    sign_in @alice
    get conversations_url
    assert_response :success
  end

  # --- Show ---
  test "show accessible for sender" do
    sign_in @alice
    get conversation_url(@message)
    assert_response :success
  end

  test "show accessible for recipient" do
    sign_in @bob
    get conversation_url(@message)
    assert_response :success
  end

  test "show redirects unauthorized user" do
    other = User.create!(email: "other@example.com", password: "password123")
    sign_in other
    get conversation_url(@message)
    assert_redirected_to conversations_url
  end

  # --- New ---
  test "new accessible when signed in" do
    sign_in @alice
    get new_conversation_url
    assert_response :success
  end

  test "new pre-selects recipient from params" do
    sign_in @alice
    get new_conversation_url(recipient_id: @bob.id)
    assert_response :success
  end

  # --- Create ---
  test "create message when signed in" do
    sign_in @alice
    assert_difference "PrivateMessage.count", 1 do
      post conversations_url, params: {
        private_message: { content: "Hello Bob!", recipient_ids: [ @bob.id ] }
      }
    end
    assert_redirected_to conversation_url(PrivateMessage.last)
  end

  test "create with empty content renders new" do
    sign_in @alice
    assert_no_difference "PrivateMessage.count" do
      post conversations_url, params: {
        private_message: { content: "", recipient_ids: [ @bob.id ] }
      }
    end
    assert_response :unprocessable_entity
  end
end
