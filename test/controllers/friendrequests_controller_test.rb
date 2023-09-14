require "test_helper"

class FriendrequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @friendrequest = friendrequests(:one)
  end

  test "should get index" do
    get friendrequests_url, as: :json
    assert_response :success
  end

  test "should create friendrequest" do
    assert_difference("Friendrequest.count") do
      post friendrequests_url, params: { friendrequest: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show friendrequest" do
    get friendrequest_url(@friendrequest), as: :json
    assert_response :success
  end

  test "should update friendrequest" do
    patch friendrequest_url(@friendrequest), params: { friendrequest: {  } }, as: :json
    assert_response :success
  end

  test "should destroy friendrequest" do
    assert_difference("Friendrequest.count", -1) do
      delete friendrequest_url(@friendrequest), as: :json
    end

    assert_response :no_content
  end
end
