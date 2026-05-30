class AttemptsController < ApplicationController
  def index
    @tab = params[:tab].presence_in(%w[sessions attempts reasons]) || "sessions"
    @attempts = Attempt.recent
    @practice_sessions = PracticeSession.with_attempts.recent
    @reason_counts = Attempt.group(:reflection_reason).count
  end

  def show
    @attempt = Attempt.find(params[:id])
  end

  def check
    @problem = Problem.find(answer_params[:problem_id])
    @submitted_answer = answer_params[:submitted_answer]
    @thought_process = answer_params[:thought_process]

    if @submitted_answer.blank? || @thought_process.blank?
      @attempt = @problem.attempts.build
      @recent_attempts = @problem.attempts.recent.limit(3)
      @attempt.assign_attributes(answer_params.except(:problem_id))
      flash.now[:alert] = "答えと考えたことを入力してください。"
      render "problems/show", status: :unprocessable_entity
      return
    end

    @result = @problem.correct_answer?(@submitted_answer) ? "correct" : "incorrect"
    @attempt = @problem.attempts.build(
      submitted_answer: @submitted_answer,
      result: @result,
      thought_process: @thought_process,
      confidence: 3
    )
  end

  def create
    @problem = Problem.find(attempt_params[:problem_id])
    @attempt = @problem.attempts.build(attempt_params.except(:problem_id))
    @attempt.result = @problem.correct_answer?(@attempt.submitted_answer) ? "correct" : "incorrect"

    if @attempt.save
      redirect_to attempts_path, notice: "振り返りを記録しました。"
    else
      @recent_attempts = @problem.attempts.recent.limit(3)
      flash.now[:alert] = "振り返りと次に気をつけることを入力してください。"
      render "problems/show", status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:attempt).permit(:problem_id, :submitted_answer, :thought_process)
  end

  def attempt_params
    params.require(:attempt).permit(:problem_id, :submitted_answer, :thought_process, :reflection_reason, :confidence, :next_focus, :note)
  end
end
