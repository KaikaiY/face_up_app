class PracticeSessionsController < ApplicationController
  def show
    @practice_session = PracticeSession.find(params[:id])
    @practice_question = @practice_session.current_question
  end

  def create
    @practice_session = PracticeSession.start_for!(
      unit: practice_session_params[:unit],
      level: practice_session_params[:level]
    )
    redirect_to @practice_session
  rescue ArgumentError
    redirect_to unit_problems_path(unit: practice_session_params[:unit]), alert: "この単元はまだランダム練習に対応していません。"
  end

  def check
    @practice_session = PracticeSession.find(params[:id])
    @practice_question = @practice_session.current_question
    @submitted_answer = params.dig(:attempt, :submitted_answer)

    if @submitted_answer.blank?
      flash.now[:alert] = "答えを入力してください。"
      render :show, status: :unprocessable_entity
      return
    end

    @result = @practice_question.correct_answer?(@submitted_answer) ? "correct" : "incorrect"
    @attempt = Attempt.new(
      practice_question: @practice_question,
      submitted_answer: @submitted_answer,
      result: @result,
      confidence: 3,
      question_snapshot: @practice_question.question,
      answer_snapshot: @practice_question.answer,
      unit: @practice_session.unit,
      level: @practice_session.level
    )
  end

  def record
    @practice_session = PracticeSession.find(params[:id])
    @practice_question = @practice_session.current_question
    @attempt = Attempt.new(record_params.merge(practice_question: @practice_question))
    @attempt.result = @practice_question.correct_answer?(@attempt.submitted_answer) ? "correct" : "incorrect"
    @attempt.question_snapshot = @practice_question.question
    @attempt.answer_snapshot = @practice_question.answer
    @attempt.unit = @practice_session.unit
    @attempt.level = @practice_session.level

    if @attempt.save
      @practice_session.advance!
      redirect_to @practice_session.complete? ? practice_session_path(@practice_session) : @practice_session
    else
      @submitted_answer = @attempt.submitted_answer
      @result = @attempt.result
      flash.now[:alert] = "振り返りを選んでください。"
      render :check, status: :unprocessable_entity
    end
  end

  private

  def practice_session_params
    params.require(:practice_session).permit(:unit, :level)
  end

  def record_params
    params.require(:attempt).permit(:submitted_answer, :reflection_reason, :confidence, :note)
  end
end
