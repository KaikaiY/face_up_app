class Problem < ApplicationRecord
  has_many :attempts, dependent: :destroy

  validates :title, :unit, :question, :answer, presence: true

  def correct_answer?(submitted_answer)
    normalize_answer(submitted_answer) == normalize_answer(answer)
  end

  private

  def normalize_answer(value)
    value.to_s
         .tr("０１２３４５６７８９　", "0123456789 ")
         .downcase
         .delete(" ")
  end
end
