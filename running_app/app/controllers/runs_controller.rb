class RunsController < ApplicationController
  before_action :authenticate_request, except: [index]

  def index
    runs = current_user.runs.order(created_at: :desc)
    total_stats = calculate_total_stats(runs)

    render json: {
      RunBlueprint.render(runs, view: :normal),
      total_stats: total_stats
    }, status: :ok
  end

  def show
    render json: RunBlueprint.render(run, view: :normal), status: :ok
  end

  def create 
    run = current_user.runs.new(run_params)

    if run.save
      render json: RunBlueprint.render(run, view: :normal), status: :created

    else
      render json: {errores: run.errors.full_messages} , status: unprocessable_entity
    end
  end

  def update
    if run.update(run_params)
      render json: RunBlueprint.render(run, view: :normal), status: :ok

    else 
      render json: run.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if run.destroy
      render json: nil, status: :ok

    else
      render json: run.errors, status: :unprocessable_entity
    end
  end

  def stats 
    runs = current_user.runs
    total_stats = calculate_total_stats(runs)

    render json: { 
      total_stats: total_stats,
       runs: runs.order(created_at: :desc)
       }, status: :ok
  end

  def set_run
    run = Run.find(params[:id])
  end

  private

  def run_params
    params.permit(:distance, :time)
  end

  def calculate_total_stats(runs)
    # total_distance = runs.sum(:distance)
    # total_time = runs.sum(:time)

    {
      total_runs: runs.count,
      total_distance: runs.sum(:distance).round(2), 
      total_time: runs.sum(:time).round(2),
      average_pace: runs.average(:pace).round(2),
      avg_speed: runs.average(:average_speed).round(2),
      total_calories: runs.sum(:calculated_calories),
      total_steps: runs.sum(:calculated_steps)
    }
  end
end
