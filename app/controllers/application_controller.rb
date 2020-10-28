class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def knowledge
      render "/knowledge"
    end
    def help
        render "/help"
      end
      def faq
          render "/faq"
        end
        def support
            render "/support"
          end
          def pricing
              render "/pricing"
            end
            def terms
                render "/terms"
              end
              def privacy
                  render "/privacy"
                end
              def media
                  render "/media"
                end
                
                def after_sign_up_path_for(resource)
                    show_cities_path(resource)
                  end 
    
  protected

  def after_sign_in_path_for(resource)
    super
  end

  def after_sign_out_path_for(*)
    new_user_session_path
  end

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end