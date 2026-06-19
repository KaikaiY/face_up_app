class PracticeQuestionGenerator
  def self.generate(unit:, level:, count:)
    new(unit, level).generate(count)
  end

  def initialize(unit, level)
    @unit = unit
    @level = level.to_i
  end

  def generate(count)
    questions = []
    attempts = 0

    while questions.size < count && attempts < count * 10
      question = build_question
      questions << question unless questions.any? { |existing| existing[:question] == question[:question] }
      attempts += 1
    end

    questions.fill { build_question } if questions.size < count
    questions
  end

  private

  attr_reader :unit, :level

  def build_question
    return arithmetic_basics_question if unit == "四則計算"
    return fraction_question if unit == "分数"
    return decimal_question if unit == "小数"
    return positive_negative_question if unit == "正負の数"
    return expression_question if unit == "文字式"
    return linear_equation_question if unit == "一次方程式"

    raise ArgumentError, "#{unit}はまだランダム練習に対応していません"
  end

  def arithmetic_basics_question
    case level
    when 1
      a = rand(1..9)
      b = rand(1..9)
      if [true, false].sample
        arithmetic_question("#{a} + #{b}", a + b, hint: "一桁のたし算です。")
      else
        minuend = rand(2..9)
        subtrahend = rand(1...minuend)
        arithmetic_question("#{minuend} - #{subtrahend}", minuend - subtrahend, hint: "一桁のひき算です。")
      end
    when 2
      a = rand(2..9)
      b = rand(2..9)
      arithmetic_question("#{a} × #{b}", a * b, hint: "九九を使って計算します。")
    when 3
      divisor = rand(2..9)
      answer = rand(1..9)
      dividend = divisor * answer
      arithmetic_question("#{dividend} ÷ #{divisor}", answer, hint: "わり算は、かけ算に戻して考えます。")
    when 4
      a = rand(1..9)
      b = rand(2..9)
      c = rand(2..9)
      if [true, false].sample
        arithmetic_question("#{a} + #{b} × #{c}", a + b * c, hint: "かけ算を先に計算します。")
      else
        dividend = b * c
        arithmetic_question("#{a} + #{dividend} ÷ #{b}", a + c, hint: "わり算を先に計算します。")
      end
    else
      raise ArgumentError, "対応していないレベルです"
    end
  end

  def fraction_question
    case level
    when 1
      denominator = rand(3..9)
      left = rand(1...denominator)
      right = rand(1...denominator)
      while right == left
        right = rand(1...denominator)
      end
      bigger = left > right ? "#{left}/#{denominator}" : "#{right}/#{denominator}"
      {
        question: "#{left}/#{denominator} と #{right}/#{denominator} はどちらが大きいですか？",
        answer: bigger,
        hint: "分母が同じときは、分子が大きい方が大きいです。"
      }
    when 2
      denominator = rand(3..9)
      a = rand(1...(denominator - 1))
      b = rand(1...(denominator - a))
      fraction_arithmetic_question("#{a}/#{denominator} + #{b}/#{denominator}", "#{a + b}/#{denominator}")
    when 3
      denominator = rand(3..9)
      a = rand(2...denominator)
      b = rand(1...a)
      fraction_arithmetic_question("#{a}/#{denominator} - #{b}/#{denominator}", "#{a - b}/#{denominator}")
    when 4
      denominator = rand(2..9)
      numerator = rand(1...denominator)
      multiplier = denominator
      answer = numerator
      fraction_arithmetic_question("#{numerator}/#{denominator} × #{multiplier}", answer.to_s)
    else
      raise ArgumentError, "対応していないレベルです"
    end
  end

  def decimal_question
    case level
    when 1
      a = rand(1..9) / 10.0
      b = rand(1..9) / 10.0
      while b == a
        b = rand(1..9) / 10.0
      end
      bigger = a > b ? format_decimal(a) : format_decimal(b)
      {
        question: "#{format_decimal(a)} と #{format_decimal(b)} はどちらが大きいですか？",
        answer: bigger,
        hint: "小数点をそろえて比べます。"
      }
    when 2
      a = rand(1..9) / 10.0
      b = rand(1..9) / 10.0
      decimal_arithmetic_question("#{format_decimal(a)} + #{format_decimal(b)}", a + b)
    when 3
      a_tenths = rand(2..9)
      b_tenths = rand(1...a_tenths)
      a = a_tenths / 10.0
      b = b_tenths / 10.0
      decimal_arithmetic_question("#{format_decimal(a)} - #{format_decimal(b)}", a - b)
    when 4
      tenths = rand(1..9) / 10.0
      multiplier = rand(2..9)
      decimal_arithmetic_question("#{format_decimal(tenths)} × #{multiplier}", tenths * multiplier)
    else
      raise ArgumentError, "対応していないレベルです"
    end
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

  def expression_question
    variable = %w[x a y b].sample

    case level
    when 1
      value = rand(1..9)
      addend = rand(1..9)
      {
        question: "#{variable} = #{value} のとき、#{variable} + #{addend} の値を求めましょう。",
        answer: (value + addend).to_s,
        hint: "文字を数に置きかえて計算します。"
      }
    when 2
      count = rand(2..5)
      {
        question: ([variable] * count).join(" + ") + " を簡単にしましょう。",
        answer: "#{count}#{variable}",
        hint: "同じ文字をいくつ分か数えます。"
      }
    when 3
      a = rand(4..9)
      b = rand(1...a)
      {
        question: "#{a}#{variable} - #{b}#{variable} を簡単にしましょう。",
        answer: "#{a - b}#{variable}",
        hint: "同じ文字の係数だけを計算します。"
      }
    when 4
      coefficient = rand(2..5)
      value = rand(1..5)
      addend = rand(1..5)
      {
        question: "#{variable} = #{value} のとき、#{coefficient}#{variable} + #{addend} の値を求めましょう。",
        answer: (coefficient * value + addend).to_s,
        hint: "文字に数を入れてから計算します。"
      }
    else
      raise ArgumentError, "対応していないレベルです"
    end
  end

  def linear_equation_question
    case level
    when 1
      answer = rand(1..9)
      addend = rand(1..9)
      {
        question: "x + #{addend} = #{answer + addend} のとき、xの値を求めましょう。",
        answer: answer.to_s,
        hint: "両側から同じ数を引きます。"
      }
    when 2
      answer = rand(2..9)
      subtrahend = rand(1..9)
      {
        question: "x - #{subtrahend} = #{answer - subtrahend} のとき、xの値を求めましょう。",
        answer: answer.to_s,
        hint: "両側に同じ数を足します。"
      }
    when 3
      coefficient = rand(2..9)
      answer = rand(1..9)
      {
        question: "#{coefficient}x = #{coefficient * answer} のとき、xの値を求めましょう。",
        answer: answer.to_s,
        hint: "両側を同じ数で割ります。"
      }
    when 4
      coefficient = rand(2..5)
      answer = rand(1..5)
      addend = rand(1..9)
      {
        question: "#{coefficient}x + #{addend} = #{coefficient * answer + addend} のとき、xの値を求めましょう。",
        answer: answer.to_s,
        hint: "先にたし算・ひき算を戻してから、xの係数で割ります。"
      }
    else
      raise ArgumentError, "対応していないレベルです"
    end
  end

  def arithmetic_question(expression, answer, hint: "符号を先に考えてから、数を計算します。")
    {
      question: "#{expression} を計算しましょう。",
      answer: answer.to_s,
      hint: hint
    }
  end

  def fraction_arithmetic_question(expression, answer)
    {
      question: "#{expression} を計算しましょう。",
      answer: answer,
      hint: "分母が同じものから練習します。"
    }
  end

  def decimal_arithmetic_question(expression, answer)
    {
      question: "#{expression} を計算しましょう。",
      answer: format_decimal(answer),
      hint: "小数点の位置を意識しましょう。"
    }
  end

  def format_decimal(value)
    rounded = value.round(1)
    rounded == rounded.to_i ? rounded.to_i.to_s : rounded.to_s
  end
end
