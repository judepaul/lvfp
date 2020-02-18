class RegistrationsController < Devise::RegistrationsController
    require 'securerandom'

    def create
        # Commented on 18/02/2020 by Jude for generating access code on demand
        # super do
        #     resource.access_code = SecureRandom.random_number(5000..9999)
        #     resource.save
        # end
        super
        set_flash_message(:notice, :signed_up_first_time)
      end

end
