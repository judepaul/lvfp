class PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication
  
  def create
    email = params[:user][:email]
    if User.exists?(email: email)
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?
      if successfully_sent?(resource)
        flash.delete(:notice)
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      else        
        respond_with(resource)
      end
    else
      redirect_to new_user_password_path, notice: "No matching email address found." 
    end
  end
  
  def instructions
    
  end
  
  
  protected
    def after_sending_reset_password_instructions_path_for(resource_name)
      auth_secret_instructions_path
    end
    
end