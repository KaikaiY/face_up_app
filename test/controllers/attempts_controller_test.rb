require "test_helper"

class AttemptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get attempts_url
    assert_response :success
  end

  test "should check answer without creating attempt" do
    assert_no_difference("Attempt.count") do
      post check_attempts_url, params: {
        attempt: {
          problem_id: problems(:one).id,
          submitted_answer: "60"
        }
      }
    end

    assert_response :success
    assert_includes response.body, "結果を見て"
  end

  test "should create attempt" do
    assert_difference("Attempt.count") do
      post attempts_url, params: {
        attempt: {
          problem_id: problems(:one).id,
          submitted_answer: "60",
          reflection_reason: "can_explain",
          confidence: 4,
          note: "説明できた"
        }
      }
    end

    assert_redirected_to attempts_url
    assert_equal "correct", Attempt.order(:created_at).last.result
  end
end
