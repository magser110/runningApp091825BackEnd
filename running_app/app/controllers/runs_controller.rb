class RunsController < ApplicationController
  before_action :authenticate_request, except: [:index, :show]
  before_action :set_run, only: [:show, :update, :destroy]

  def index
    result = RunService::Base.filter_runs(params)
    if result.success?
      render_success(payload: RunBlueprint.render_as_hash(result.payload, view: :normal, current_user: @current_user, total_stats: calculate_total_stats(result.payload)
      ), status: :ok)
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
    # runs = current_user.runs.order(created_at: :desc)
    # total_stats = calculate_total_stats(runs)

    # render json: {
    #   # RunBlueprint.render(runs, view: :normal)
    #   total_stats: total_stats
    # }, status: :ok
  end

  def show
    render json: RunBlueprint.render(@run, view: :normal), status: :ok
  end

  def create 

    run = current_user.runs.new(run_params)

    if run.save
      render json: RunBlueprint.render(run, view: :normal), status: :created

    else
      render json: {errores: run.errors.full_messages} , status: :unprocessable_entity
    end
  end

  def update
    puts @run.id
    if @run.update!(run_params)
      # render json: RunBlueprint.render(@run, view: :normal), status: :ok
      render json: @run, status: :ok

    else 
      render json: @run.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @run.destroy
      render json: { message: "run successfully deleted"}, status: :ok

    else
      render json: @run.errors, status: :unprocessable_entity
    end
  end

  def stats 
    runs = current_user.runs
    total_stats = calculate_total_stats(runs)

    render json: { 
      total_stats: total_stats,
       runs: RunBlueprint.render(runs.order(created_at: :desc), view: :normal, current_user: @current_user)
       }, status: :ok
  end

  def set_run
    @run = Run.find(params[:id])
  end

  private

  def run_params
    params.require(:run).permit(:distance, :time, :date)
  end

def calculate_total_stats(runs)
  total_distance = runs.sum(:distance).to_f
  total_time     = runs.sum(:time).to_f

  overall_stats = {
    total_runs: runs.size,
    total_distance: total_distance.round(2),
    total_time: total_time.round(2),
    average_pace: runs.any? ? (total_time / total_distance).round(2) : 0,
    avg_speed: runs.any? ? (total_distance / total_time).round(2) : 0,
    # total_calories: runs.sum(:calculated_calories).to_i, # if this is stored
    # total_steps: runs.sum(:calculated_steps).to_i        # if this is stored
  }
  individual_stats = runs.map do |run|
    {
      id: run.id,
      distance: run.distance,
      time: run.time,
      date: run.date,
      pace: run.pace.round(2),
      average_speed: run.average_speed.round(2),
      # calories_burned: run.calculated_calories.to_i,
      # steps: run.calculated_steps.to_i

  }
end

end
  # def calculate_total_stats(runs)
  #   puts runs
  #   # total_distance = runs.sum(:distance)
  #   # total_time = runs.sum(:time)

  #   {
  #     total_runs: runs.count,
  #     total_distance: runs.sum(:distance).round(2), 
  #     total_time: runs.sum(:time).round(2),
  #     average_pace: runs.average(:pace).round(2),
  #     avg_speed: runs.average(:average_speed).round(2),
  #     total_calories: runs.sum(:calculated_calories).to_i,
  #     total_steps: runs.sum(:calculated_steps).to_i
  #   }
  # end
# }
end
