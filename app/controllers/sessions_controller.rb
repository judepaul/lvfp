class SessionsController < Devise::SessionsController
     protect_from_forgery prepend: true
    def create
        resource = warden.authenticate!(:scope => resource_name)
        if is_navigational_format?
          if resource.sign_in_count == 1
            set_flash_message(:notice, :signed_in_first_time, access_code: resource.access_code)
          else
            #set_flash_message(:notice, :signed_in)
          end
        end
        sign_in(resource_name, resource)
        # Commented by Jude on 03/04/2020, to show the dashboard for the vc_admins too
        # if resource.super_vc_admin?
        #   redirect_to dashboard_index_path
        # else
        #   redirect_to access_codes_path
        # end
        redirect_to dashboard_index_path
    end

    def destroy
        super
        flash.delete(:notice)
    end

end
