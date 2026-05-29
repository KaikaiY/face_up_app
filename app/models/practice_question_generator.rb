class PracticeQuestionGenerator
  def self.generate(unit:, level:, count:)
    new(unit, level).generate(count)
  end

  def initialize(unit, level)
    @unit = unit
    @level = level.to_i
  end

  def generate(count)
    count.times.map { build_question }
  end

  private

  attr_reader :unit, :level

  def build_question
    return positive_negative_question if unit == "正負の数"

    raise ArgumentError, "#{unit}はまだランダム練習に対応していません"
  end

  def positive_negative_question
    case level
    when 1
      value = [*1..9, *(-9..-1)].sample
      {
        question: "#{value} は 0 より大きいですか？小さいですか？",
        answer: value.positive? ? "大きい" : "小さい",
        hint: "数直線で0の右か左かを考えます。"
      }
    when 2
      a = -rand(1..9)
      b = rand(1..9)
      arithmetic_question("#{a} + #{b}", a + b)
    when 3
      a = rand(1..8)
      b = rand((a + 1)..9)
      arithmetic_question("#{a} - #{b}", a - b)
    when 4
      a = [-1, 1].sample * rand(1..9)
      b = [-1, 1].sample * rand(1..9)
      arithmetic_question("#{a} × #{b}", a * b)
    when 5
      answer = [-1, 1].sample * rand(1..9)
      divisor = [-1, 1].sample * rand(1..9)
      dividend = answer * divisor
      arithmetic_question("#{dividend} ÷ #{divisor}", answer)
    else
      raise ArgumentError, "対応していないレベルです"
    end
  end

  def arithmetic_question(expression, answer)
    {
      question: "#{expression} を計算しましょう。",
      answer: answer.to_s,
      hint: "符号を先に考えてから、数を計算します。"
    }
  end
end
