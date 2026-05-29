require "test_helper"

class ProblemTest < ActiveSupport::TestCase
  test "normalizes full width numbers decimals and minus signs" do
    assert problems(:two).correct_answer?("１２")

    decimal_problem = Problem.new(title: "小数", unit: "小数", question: "test", answer: "2.15")
    assert decimal_problem.correct_answer?("２．１５")

    negative_problem = Problem.new(title: "負の数", unit: "正負の数", question: "test", answer: "-6")
    assert negative_problem.correct_answer?("−６")
  end
end
