class RunsController < ApplicationController
  before_action :authenticate_request, except: [index]

  def index
    runs = Run.all
    render json: RunBlueprint.render(runs, view: :normal), status: :ok
  end

  def show
    render json: RunBlueprint.render(run, view: :normal), status: :ok
  end

  def create 
    run = Run.new(run_params)

    if run.save
      render json: RunBlueprint.render(run, view: :normal), status: :created

    else
      render json: run.errors, status: unprocessable_entity
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

  def set_run
    run = Run.find(params[:id])
  end

  def run_params
    params.permit(:distance, :time)
  end
end
