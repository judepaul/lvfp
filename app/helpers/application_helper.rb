module ApplicationHelper
    def bootstrap_class_for_flash(flash_type)
        case flash_type
        when 'success'
          'alert-success'
        when 'error'
          'alert-danger'
        when 'alert'
          'alert-warning'
        when 'notice'
          'alert-info'
        else
          flash_type.to_s
        end
      end

      def current_class?(url_path)
        # p request.path.include?('articles')
        if request.path.include?("/voice-reader-studio/campaigns") || request.path.include?("/voice-reader-studio/articles")
          class_name = "access_codes"
        elsif request.path.include?("/voice-reader-skill/details")
          class_name = "skills"
        end
        p "!@!@!@!@"
        p class_name
        return class_name
      end
end
