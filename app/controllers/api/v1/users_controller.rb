class Api::V1::UsersController < ApplicationController
  
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end
  
  def user_params
      params.require(:user).permit(:email, :mobile_number, :password, :password_confirmation)
  end

end
