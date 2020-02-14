class SessionsController < Devise::SessionsController
    def create
        resource = warden.authenticate!(:scope => resource_name)
        if is_navigational_format?
          if resource.sign_in_count == 1
            set_flash_message(:notice, :signed_in_first_time, access_code: resource.access_code)
          else
            set_flash_message(:notice, :signed_in)
          end
        end
        sign_in(resource_name, resource)
        redirect_to root_path
    end

    def destroy
        super
    end

end
