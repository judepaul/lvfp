class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.role == "super_vc_admin"
      @users = User.where('role!=3').paginate(page: params[:page])
    end
  end
  
  def edit
    @user = current_user
  end

  def update_password
    @user = current_user
    username = params[:user][:username]
    if User.exists?(username: username)
            redirect_to edit_user_path, notice: "Username already exists. Try with another one" 
    else
      if @user.update(user_params)
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(@user)
        redirect_to root_path
      else
        render "edit"
      end
    end
  end
  
  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
  
end
