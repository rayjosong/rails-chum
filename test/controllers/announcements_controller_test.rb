require "test_helper"

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get announcements_create_url
    assert_response :success
  end
end
