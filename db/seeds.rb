# This file should ensure the existence of records required to run the application in every environment.

problems = []

def add_problem(problems, unit:, level:, name:, number:, question:, answer:, hint:, previous_title: nil)
  problems << {
    title: "#{name} #{number}",
    unit: unit,
    level: level,
    question: question,
    answer: answer,
    hint: hint,
    previous_title: previous_title
  }
end

[
  ["たし算とひき算", 1, [["3 + 5", "8"], ["8 - 2", "6"], ["4 + 2", "6"], ["9 - 6", "3"]]],
  ["かけ算", 2, [["2 × 3", "6"], ["4 × 2", "8"], ["3 × 3", "9"], ["5 × 2", "10"]]],
  ["わり算", 3, [["6 ÷ 2", "3"], ["8 ÷ 4", "2"], ["9 ÷ 3", "3"], ["10 ÷ 5", "2"]]],
  ["計算の順序", 4, [["2 + 3 × 4", "14"], ["8 - 2 × 3", "2"], ["6 ÷ 2 + 5", "8"], ["4 + 8 ÷ 2", "8"]]]
].each do |name, level, exercises|
  exercises.each.with_index(1) do |(expression, answer), number|
    add_problem(
      problems,
      unit: "四則計算",
      level: level,
      name: name,
      number: number,
      question: "#{expression} を計算しましょう。",
      answer: answer,
      hint: level == 4 ? "かけ算・わり算を先に計算します。" : "一桁の数で、落ち着いて計算しましょう。",
      previous_title: number == 1 ? "四則計算 #{level}" : nil
    )
  end
end

[
  ["分数の大きさ", 1, [["1/2 と 1/3 はどちらが大きいですか？", "1/2"], ["1/4 と 1/5 はどちらが大きいですか？", "1/4"], ["2/3 と 1/3 はどちらが大きいですか？", "2/3"], ["3/5 と 1/5 はどちらが大きいですか？", "3/5"]]],
  ["分数の足し算", 2, [["1/5 + 2/5", "3/5"], ["1/6 + 3/6", "4/6"], ["2/7 + 1/7", "3/7"], ["3/8 + 2/8", "5/8"]]],
  ["分数の引き算", 3, [["4/5 - 1/5", "3/5"], ["5/6 - 2/6", "3/6"], ["6/7 - 3/7", "3/7"], ["7/8 - 2/8", "5/8"]]],
  ["分数のかけ算", 4, [["1/2 × 4", "2"], ["1/3 × 6", "2"], ["2/5 × 5", "2"], ["3/4 × 4", "3"]]]
].each do |name, level, exercises|
  exercises.each.with_index(1) do |(expression, answer), number|
    add_problem(
      problems,
      unit: "分数",
      level: level,
      name: name,
      number: number,
      question: level == 1 ? expression : "#{expression} を計算しましょう。",
      answer: answer,
      hint: level == 1 ? "分母が大きいほど、1つ分は小さくなります。" : "分母が同じものから練習します。",
      previous_title: number == 1 ? "分数 #{level}" : nil
    )
  end
end

[
  ["小数の大きさ", 1, [["0.3 と 0.7 はどちらが大きいですか？", "0.7"], ["0.5 と 0.2 はどちらが大きいですか？", "0.5"], ["1.2 と 1.4 はどちらが大きいですか？", "1.4"], ["2.1 と 1.9 はどちらが大きいですか？", "2.1"]]],
  ["小数の足し算", 2, [["0.2 + 0.3", "0.5"], ["0.4 + 0.5", "0.9"], ["1.2 + 0.3", "1.5"], ["2.1 + 0.6", "2.7"]]],
  ["小数の引き算", 3, [["0.8 - 0.3", "0.5"], ["0.9 - 0.4", "0.5"], ["1.5 - 0.2", "1.3"], ["2.7 - 0.6", "2.1"]]],
  ["小数のかけ算", 4, [["0.2 × 3", "0.6"], ["0.4 × 2", "0.8"], ["1.2 × 2", "2.4"], ["0.5 × 6", "3"]]]
].each do |name, level, exercises|
  exercises.each.with_index(1) do |(expression, answer), number|
    add_problem(
      problems,
      unit: "小数",
      level: level,
      name: name,
      number: number,
      question: level == 1 ? expression : "#{expression} を計算しましょう。",
      answer: answer,
      hint: level == 1 ? "小数点をそろえて、左から比べます。" : "小数点の位置を意識しましょう。",
      previous_title: number == 1 ? "小数 #{level}" : nil
    )
  end
end

[
  ["符号の意味", 1, [["-3 は 0 より大きいですか？小さいですか？", "小さい"], ["5 は 0 より大きいですか？小さいですか？", "大きい"], ["-1 は 0 より大きいですか？小さいですか？", "小さい"], ["2 は 0 より大きいですか？小さいですか？", "大きい"]]],
  ["正負の足し算", 2, [["-3 + 5", "2"], ["-2 + 6", "4"], ["4 + -1", "3"], ["-5 + 2", "-3"]]],
  ["正負の引き算", 3, [["4 - 7", "-3"], ["2 - 5", "-3"], ["6 - 9", "-3"], ["3 - 8", "-5"]]],
  ["正負のかけ算", 4, [["-3 × 4", "-12"], ["-2 × 5", "-10"], ["3 × -2", "-6"], ["-4 × -2", "8"]]],
  ["正負の割り算", 5, [["-12 ÷ -3", "4"], ["-8 ÷ 2", "-4"], ["9 ÷ -3", "-3"], ["-6 ÷ -2", "3"]]]
].each do |name, level, exercises|
  exercises.each.with_index(1) do |(expression, answer), number|
    add_problem(
      problems,
      unit: "正負の数",
      level: level,
      name: name,
      number: number,
      question: level == 1 ? expression : "#{expression} を計算しましょう。",
      answer: answer,
      hint: level == 1 ? "数直線で0の右か左かを考えます。" : "符号を先に考えてから、数を計算します。",
      previous_title: number == 1 ? ["正負の数 #{level}", name].find { |title| Problem.exists?(title: title) } : nil
    )
  end
end

[
  ["文字に数を入れる", 1, [["a = 2 のとき、a + 3 の値", "5"], ["x = 4 のとき、x + 2 の値", "6"], ["b = 5 のとき、b - 1 の値", "4"], ["y = 3 のとき、2y の値", "6"]]],
  ["同じ文字をまとめる", 2, [["x + x", "2x"], ["a + a + a", "3a"], ["2y + y", "3y"], ["3b + b", "4b"]]],
  ["文字式のひき算", 3, [["5x - 2x", "3x"], ["4a - a", "3a"], ["6y - 3y", "3y"], ["7b - 5b", "2b"]]],
  ["文字式の値", 4, [["a = 2 のとき、3a + 1 の値", "7"], ["x = 3 のとき、2x + 2 の値", "8"], ["b = 4 のとき、b + 5 の値", "9"], ["y = 2 のとき、4y - 1 の値", "7"]]]
].each do |name, level, exercises|
  exercises.each.with_index(1) do |(expression, answer), number|
    add_problem(
      problems,
      unit: "文字式",
      level: level,
      name: name,
      number: number,
      question: "#{expression}を求めましょう。",
      answer: answer,
      hint: level == 1 || level == 4 ? "文字を数に置きかえて計算します。" : "同じ文字の項だけをまとめます。",
      previous_title: number == 1 ? "文字式 #{level}" : nil
    )
  end
end

[
  ["たし算の方程式", 1, [["x + 2 = 5", "3"], ["x + 3 = 7", "4"], ["x + 1 = 6", "5"], ["x + 4 = 9", "5"]]],
  ["ひき算の方程式", 2, [["x - 2 = 4", "6"], ["x - 3 = 5", "8"], ["x - 1 = 6", "7"], ["x - 4 = 3", "7"]]],
  ["かけ算の方程式", 3, [["2x = 6", "3"], ["3x = 9", "3"], ["4x = 8", "2"], ["5x = 10", "2"]]],
  ["二手の方程式", 4, [["2x + 1 = 7", "3"], ["3x + 2 = 8", "2"], ["2x - 1 = 5", "3"], ["4x - 3 = 5", "2"]]]
].each do |name, level, exercises|
  exercises.each.with_index(1) do |(expression, answer), number|
    add_problem(
      problems,
      unit: "一次方程式",
      level: level,
      name: name,
      number: number,
      question: "#{expression} のとき、xの値を求めましょう。",
      answer: answer,
      hint: level < 3 ? "xだけを左に残すように考えます。" : "逆の計算で、xだけを残します。",
      previous_title: number == 1 ? "一次方程式 #{level}" : nil
    )
  end
end

problems.each do |attributes|
  previous_title = attributes.delete(:previous_title)
  problem = Problem.find_by(title: attributes[:title])
  problem ||= Problem.find_by(title: previous_title) if previous_title.present?
  problem ||= Problem.new
  problem.update!(attributes)
end

seeded_titles = problems.map { |problem| problem[:title] }
Problem.curriculum.left_joins(:attempts).where(attempts: { id: nil }).where.not(title: seeded_titles).destroy_all
Problem.where(title: ["割合の基本", "一次方程式", "平均", "面積"]).left_joins(:attempts).where(attempts: { id: nil }).destroy_all
