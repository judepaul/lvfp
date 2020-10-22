class RegistrationsController < Devise::RegistrationsController
    require 'securerandom'    

    def new
      p params[:confirmation_token]
      @email = params["email"] unless params["email"].nil?
      super
    end
    
    def create
        # Commented on 18/02/2020 by Jude for generating access code on demand
        # super do
        #     resource.access_code = SecureRandom.random_number(5000..9999)
        #     resource.save
        # end
        username = params[:user][:username]
        p User.exists?(username: username)
     if User.exists?(username: username)
        redirect_to new_user_registration_path, notice: "Username already exists. Try with another one" 
     else
        super
        #set_flash_message(:notice, :signed_up_first_time)
      end

    end

    def check_username
      p "@@@@@@@@@"
      @user = User.find_by_username(params[:user][:username])
      p "!!!!"
      p @user
      respond_to do |format|
       format.json { render :json => !@user }
      end
    end
    
    protected 
    def configure_permitted_parameters
       devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :firstname, :lastname])
       # devise_parameter_sanitizer.for(:account_update).push(:name, :surname, :email, :avatar)
    end
end
