class SkillsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def root
      input = AlexaRubykit.build_request(params)
      output = AlexaRubykit::Response.new
      session_end = true
      message = "There was an error." # unknown thing happened
      device_id =  params["context"]["System"]["device"]["deviceId"]
      voice_user_id = params["context"]["System"]["user"]["userId"]
      case input.type
      when "LAUNCH_REQUEST"
        if Audiance.check_device_exists(device_id).blank?
          message = "Hello! welcome to voice chimp; Please say your access code to get started."
          session_end = false
        else
          vc_id = Audiance.check_device_exists(device_id).last.user_id
          content = UserContentMap.where(user_id: vc_id).last.speech.content
          message = "Hello! welcome to voice chimp. Here is your latest email. #{content}"; 
        end  
      when "INTENT_REQUEST"
        case input.name
        when 'AccessCode'   
          access_code = input.slots["access_code"]["value"]       
          # message = "You said, #{given}."
          if User.pluck(:access_code).include?access_code.to_i
          # if access_code == '9964'
            vc_admin_id = User.user_by_code(access_code)[0].id
            Audiance.create(voice_user_id: voice_user_id, device_id: device_id, user_id:vc_admin_id)
            content = UserContentMap.where(user_id: vc_admin_id).last.speech.content
            if content.blank?
              message = 'Sorry! I couldn\'t find any content avaiable for the code that you are asking'
            else
              message = content;
            end
          else
            message = 'Sorry i can\'t recognize the access code.';
          end
        when 'AMAZON.CancelIntent'
            message = 'Cancel intent handler in rails application'
        when 'AMAZON.StopIntent'
            message = 'Stop intent handler in rails application'
        when 'helloIntent'
            message = 'Hello, Awesome you are in custom intent handler. Say stop or cancel to exist'
            session_end = false
        when 'AMAZON.YesIntent'
            message = 'You can say Hello and I will greet you to start with application or say stop or cancel to exist'
            session_end = false
        when 'AMAZON.NoIntent'
            message = 'Okay Talk to you later' 
        end
   #      when "UserInput"
   #        # our custom, simple intent from above that user matched
   #        given = input.slots["Generic"].value
   #        message = "You said, #{given}."
   #      end
       
     when "SESSION_ENDED_REQUEST"
        # it's over
        message = nil
      end
  
      output.add_speech(message) unless message.blank?
      render json: output.build_response(session_end)
    end

    protected

    def get_content_by_access_code access_code
      
    end

end



