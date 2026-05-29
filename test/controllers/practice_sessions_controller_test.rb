require "test_helper"

class PracticeSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get practice_session_url(practice_sessions(:one))
    assert_response :success
  end

  test "should create random practice session" do
    assert_difference("PracticeSession.count") do
      assert_difference("PracticeQuestion.count", 4) do
        post practice_sessions_url, params: {
          practice_session: {
            unit: "正負の数",
            level: 2
          }
        }
      end
    end

    assert_redirected_to practice_session_url(PracticeSession.order(:created_at).last)
  end

  test "should check answer without recording attempt" do
    assert_no_difference("Attempt.count") do
      post check_practice_session_url(practice_sessions(:one)), params: {
        attempt: {
          submitted_answer: "小さい"
        }
      }
    end

    assert_response :success
    assert_includes response.body, "結果を見て"
  end

  test "should record attempt and advance" do
    session = practice_sessions(:one)

    assert_difference("Attempt.count") do
      post record_practice_session_url(session), params: {
        attempt: {
          submitted_answer: "小さい",
          reflection_reason: "can_explain",
          confidence: 4,
          note: "わかった"
        }
      }
    end

    assert_redirected_to practice_session_url(session)
    assert_equal 2, session.reload.current_position
  end
end
