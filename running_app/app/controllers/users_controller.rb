class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create 
    user = User.new(user_params)
    if user.save
      token = JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
      response.set_header('Authorization', "Bearer #{token}")
      render json: {
        user: user.as_json(except: [:password_digest]), 
        token: token
      }, status: :created
      
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity 
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :height, 
      :weight,
      :gender,
      :age,
      :password, 
      :password_confirmation)
  end
end
