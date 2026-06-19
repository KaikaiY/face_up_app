require "test_helper"

class PracticeQuestionGeneratorTest < ActiveSupport::TestCase
  test "generates four questions for every curriculum unit level" do
    expected_levels = {
      "四則計算" => 1..4,
      "分数" => 1..4,
      "小数" => 1..4,
      "正負の数" => 1..5,
      "文字式" => 1..4,
      "一次方程式" => 1..4
    }

    expected_levels.each do |unit, levels|
      levels.each do |level|
        questions = PracticeQuestionGenerator.generate(unit: unit, level: level, count: 4)

        assert_equal 4, questions.size, "#{unit} level #{level}"
        assert questions.all? { |question| question[:question].present? }
        assert questions.all? { |question| question[:answer].present? }
      end
    end
  end
end
