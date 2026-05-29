require "test_helper"

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get problems_url
    assert_response :success
  end

  test "should get index with practice attempt" do
    Attempt.create!(
      practice_question: practice_questions(:one),
      submitted_answer: "小さい",
      result: "correct",
      reflection_reason: "can_explain",
      confidence: 4,
      question_snapshot: practice_questions(:one).question,
      answer_snapshot: practice_questions(:one).answer,
      unit: practice_sessions(:one).unit,
      level: practice_sessions(:one).level
    )

    get problems_url
    assert_response :success
  end

  test "should get unit" do
    get unit_problems_url(unit: problems(:one).unit)
    assert_response :success
  end

  test "should get show" do
    get problem_url(problems(:one))
    assert_response :success
  end
end
