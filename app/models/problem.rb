class Problem < ApplicationRecord
  CURRICULUM_UNITS = ["四則計算", "分数", "小数", "正負の数", "文字式", "一次方程式"].freeze

  has_many :attempts, dependent: :destroy

  validates :title, :unit, :question, :answer, presence: true
  validates :level, inclusion: { in: 1..5 }

  scope :curriculum, -> { where(unit: CURRICULUM_UNITS) }
  scope :by_level, -> { order(:level, :id) }

  def level_label
    "レベル#{level}"
  end

  def correct_answer?(submitted_answer)
    normalize_answer(submitted_answer) == normalize_answer(answer)
  end

  private

  def normalize_answer(value)
    value.to_s
         .tr("０１２３４５６７８９．，　", "0123456789.. ")
         .gsub(/[－−]/, "-")
         .downcase
         .delete(" ")
  end
end
