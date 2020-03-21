class RegistrationsController < Devise::RegistrationsController
    require 'securerandom'

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
        set_flash_message(:notice, :signed_up_first_time)
        super
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
    

end
