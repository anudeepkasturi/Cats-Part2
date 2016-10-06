class UsersController < ApplicationController

  def new

  end

  #create new user
  def create

    user = User.new(user_params)
    if user.valid?
      user.save
      login(user)
      redirect_to user_url(current_user)
    else
      render :new
      flash.now[:error] = user.errors.full_messages
    end
  end

  def show
    if current_user.id == params[:id].to_i
      @user = current_user
      render :show
    else
      redirect_to new_session_url
    end
  end


  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
