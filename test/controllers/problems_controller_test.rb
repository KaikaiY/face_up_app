require "test_helper"

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get problems_url
    assert_response :success
  end

  test "should get show" do
    get problem_url(problems(:one))
    assert_response :success
  end
end
