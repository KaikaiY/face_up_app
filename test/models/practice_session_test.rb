require "test_helper"

class PracticeSessionTest < ActiveSupport::TestCase
  test "summary recommends next level when all answers are explainable" do
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

    summary = session.summary

    assert_equal 4, summary[:correct_count]
    assert_equal "説明できる", summary[:main_reason_label]
    assert_equal "次のレベルへ進んでよさそうです。", summary[:recommendation]
  end

  test "summary recommends retry when lucky guesses are common" do
    session = PracticeSession.create!(unit: "正負の数", level: 2, current_position: 4, completed_at: Time.current)
    4.times do |index|
      question = session.practice_questions.create!(
        position: index + 1,
        question: "-3 + 5 を計算しましょう。",
        answer: "2"
      )
      Attempt.create!(
        practice_question: question,
        submitted_answer: "2",
        result: "correct",
        reflection_reason: "lucky_guess",
        thought_process: "なんとなく足した",
        next_focus: "explain_before_next",
        confidence: 2,
        question_snapshot: question.question,
        answer_snapshot: question.answer,
        unit: session.unit,
        level: session.level
      )
    end

    assert_equal "同じレベルをもう一度やって、説明できるか確かめましょう。", session.summary[:recommendation]
  end
end
