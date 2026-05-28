class ProblemsController < ApplicationController
  def index
    @problems = Problem.order(:unit, :id)
    @attempts = Attempt.recent.limit(6)
    @reason_counts = Attempt.group(:reflection_reason).count
  end

  def show
    @problem = Problem.find(params[:id])
    @attempt = @problem.attempts.build(confidence: 3)
    @recent_attempts = @problem.attempts.recent.limit(3)
  end
end
