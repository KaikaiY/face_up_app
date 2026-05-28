# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

problems = [
  {
    title: "割合の基本",
    unit: "割合",
    question: "300円の20%はいくらですか？",
    answer: "60",
    hint: "20%は 0.2 と同じです。300に0.2をかけてみましょう。"
  },
  {
    title: "一次方程式",
    unit: "方程式",
    question: "x + 7 = 19 のとき、xの値はいくつですか？",
    answer: "12",
    hint: "両側から7を引くと、xだけが残ります。"
  },
  {
    title: "平均",
    unit: "データ",
    question: "8点、10点、12点の平均は何点ですか？",
    answer: "10",
    hint: "全部の点数を足して、個数の3で割ります。"
  },
  {
    title: "面積",
    unit: "図形",
    question: "縦が6cm、横が9cmの長方形の面積は何平方cmですか？",
    answer: "54",
    hint: "長方形の面積は、縦 × 横です。"
  }
]

problems.each do |attributes|
  Problem.find_or_create_by!(title: attributes[:title]) do |problem|
    problem.unit = attributes[:unit]
    problem.question = attributes[:question]
    problem.answer = attributes[:answer]
    problem.hint = attributes[:hint]
  end
end
