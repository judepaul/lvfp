class ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  def create
    email = params[:user][:email]
    p User.exists?(email: email)
    if User.exists?(email: email)
      p "resource_class.send_confirmation_instructions(resource_params)"
      p resource_class.send_confirmation_instructions(resource_params)
      self.resource = resource_class.send_confirmation_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    elsif User.where(email: email).where( "confirmation_token IS NULL " ).present?
      redirect_to new_user_confirmation_path, notice: "No matching email address found." 
    else
      p "@@@@"
      redirect_to new_user_confirmation_path, notice: "No matching email address found." 
    end
  end

  def show
      if params[:confirmation_token].present?
        @original_token = params[:confirmation_token]
      elsif params[resource_name].try(:[], :confirmation_token).present?
        @original_token = params[resource_name][:confirmation_token]
      end
      self.role = 2
      self.resource = resource_class.find_by_confirmation_token @original_token
    end

    def confirm
      @original_token = params[resource_name].try(:[], :confirmation_token)

      self.resource = resource_class.find_by_confirmation_token! @original_token
      resource.assign_attributes(permitted_params) unless params[resource_name].nil?

      if resource.valid? && resource.password_match?
        self.resource.confirm
        set_flash_message :notice, :confirmed
        sign_in_and_redirect resource_name, resource
      else
        render :action => 'show'
      end
    end

   private
     def permitted_params
       params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
     end


end