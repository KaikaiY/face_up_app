class AttemptsController < ApplicationController
  def index
    @attempts = Attempt.recent
    @reason_counts = Attempt.group(:reflection_reason).count
  end

  def create
    @problem = Problem.find(attempt_params[:problem_id])
    @attempt = @problem.attempts.build(attempt_params.except(:problem_id))
    @attempt.result = @problem.correct_answer?(@attempt.submitted_answer) ? "correct" : "incorrect"

    if @attempt.save
      redirect_to attempts_path, notice: "振り返りを記録しました。"
    else
      @recent_attempts = @problem.attempts.recent.limit(3)
      flash.now[:alert] = "答えと振り返りを入力してください。"
      render "problems/show", status: :unprocessable_entity
    end
  end

  private

  def attempt_params
    params.require(:attempt).permit(:problem_id, :submitted_answer, :reflection_reason, :confidence, :note)
  end
end
