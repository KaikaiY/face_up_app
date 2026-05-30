require "test_helper"

class AttemptsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get attempts_url
    assert_response :success
  end

  test "should get attempts tab" do
    get attempts_url(tab: "attempts")
    assert_response :success
    assert_includes response.body, "1問ごと"
  end

  test "should get reasons tab" do
    get attempts_url(tab: "reasons")
    assert_response :success
    assert_includes response.body, "理由の集計"
  end

  test "should show fixed problem attempt" do
    get attempt_url(attempts(:one))
    assert_response :success
    assert_includes response.body, attempts(:one).submitted_answer
  end

  test "should show practice attempt" do
    attempt = Attempt.create!(
      practice_question: practice_questions(:one),
      submitted_answer: "小さい",
      result: "correct",
      reflection_reason: "can_explain",
      thought_process: "0より左にあると思った",
      next_focus: "explain_before_next",
      confidence: 4,
      question_snapshot: practice_questions(:one).question,
      answer_snapshot: practice_questions(:one).answer,
      unit: practice_sessions(:one).unit,
      level: practice_sessions(:one).level,
      note: "数直線でわかった"
    )

    get attempt_url(attempt)
    assert_response :success
    assert_includes response.body, practice_questions(:one).question
    assert_includes response.body, "数直線でわかった"
  end

  test "should check answer without creating attempt" do
    assert_no_difference("Attempt.count") do
      post check_attempts_url, params: {
        attempt: {
          problem_id: problems(:one).id,
          submitted_answer: "60",
          thought_process: "足し算で考えた"
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
          thought_process: "足し算で考えた",
          reflection_reason: "can_explain",
          next_focus: "explain_before_next",
          confidence: 4,
          note: "説明できた"
        }
      }
    end

    assert_redirected_to attempts_url
    assert_equal "correct", Attempt.order(:created_at).last.result
  end
end
