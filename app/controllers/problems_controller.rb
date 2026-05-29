class ProblemsController < ApplicationController
  def index
    @units = Problem.curriculum.group(:unit).count
    @units = Problem::CURRICULUM_UNITS.index_with { |unit| @units.fetch(unit, 0) }
    @attempts = Attempt.recent.limit(6)
    @reason_counts = Attempt.group(:reflection_reason).count
  end

  def unit
    @unit = params[:unit]
    redirect_to problems_path, alert: "単元が見つかりませんでした。" and return unless Problem::CURRICULUM_UNITS.include?(@unit)

    @problems = Problem.where(unit: @unit).by_level
    @problems_by_level = @problems.group_by(&:level)
    @attempts = Attempt.joins(:problem).where(problems: { unit: @unit }).recent.limit(6)

    redirect_to problems_path, alert: "単元が見つかりませんでした。" if @problems.empty?
  end

  def show
    @problem = Problem.find(params[:id])
    @attempt = @problem.attempts.build(confidence: 3)
    @recent_attempts = @problem.attempts.recent.limit(3)
  end
end
