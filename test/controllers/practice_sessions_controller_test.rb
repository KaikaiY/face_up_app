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

  test "should create random practice sessions for all units" do
    %w[四則計算 分数 小数 正負の数 文字式 一次方程式].each do |unit|
      assert_difference("PracticeSession.count") do
        assert_difference("PracticeQuestion.count", 4) do
          post practice_sessions_url, params: {
            practice_session: {
              unit: unit,
              level: 1
            }
          }
        end
      end
    end
  end

  test "should check answer without recording attempt" do
    assert_no_difference("Attempt.count") do
      post check_practice_session_url(practice_sessions(:one)), params: {
        attempt: {
          submitted_answer: "小さい",
          thought_process: "0より左にあると思った"
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
          thought_process: "0より左にあると思った",
          reflection_reason: "can_explain",
          next_focus: "explain_before_next",
          confidence: 4,
          note: "わかった"
        }
      }
    end

    assert_redirected_to practice_session_url(session)
    assert_equal 2, session.reload.current_position
  end

  test "should show summary for completed session" do
    session = PracticeSession.create!(unit: "正負の数", level: 1, current_position: 4, completed_at: Time.current)
    4.times do |index|
      question = session.practice_questions.create!(
        position: index + 1,
        question: "-1 は 0 より大きいですか？小さいですか？",
        answer: "小さい"
      )
      Attempt.create!(
        practice_question: question,
        submitted_answer: "小さい",
        result: "correct",
        reflection_reason: "can_explain",
        thought_process: "0より左にあると思った",
        next_focus: "explain_before_next",
        confidence: 4,
        question_snapshot: question.question,
        answer_snapshot: question.answer,
        unit: session.unit,
        level: session.level
      )
    end

    get practice_session_url(session)

    assert_response :success
    assert_includes response.body, "今回のまとめ"
    assert_includes response.body, "次におすすめ"
  end
end
