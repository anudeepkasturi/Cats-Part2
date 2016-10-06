class SessionsController < ApplicationController
# create a new user is new log in is create
  def new
  end

  def create
    user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    if user
      login(user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def destroy
    logout(current_user)
    redirect_to new_session_url
  end

  private
  def session_params
    params.require(:user).permit(:user_name, :password)
  end
end
