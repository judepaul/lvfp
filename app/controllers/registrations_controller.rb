class RegistrationsController < Devise::RegistrationsController
    require 'securerandom'

    def create
        super do
            resource.access_code = SecureRandom.random_number(5000..9999)
            resource.save
        end
        set_flash_message(:notice, :signed_up_first_time, access_code: resource.access_code) if resource.save
      end

end
