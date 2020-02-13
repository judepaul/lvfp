class SkillsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def root
      input = AlexaRubykit.build_request(params)
      output = AlexaRubykit::Response.new
      session_end = true
      message = "There was an error." # unknown thing happened
      p input.type
      case input.type
      when "LAUNCH_REQUEST"
        # user talked to our skill but did not say something matching intent
        message = "Hello! welcome to voice chimp; Please say your access code to get started."
        session_end = false
      when "INTENT_REQUEST"
        p input.name
        case input.name
        when 'AccessCode'
          p "ACCESS CODE ==> #{input.slots["access_code"]["value"]}"
          access_code = input.slots["access_code"]["value"]
          # message = "You said, #{given}."
          if access_code == '555'
            message = Speech.where(code: access_code).first.content
          elsif access_code == '444'
            message = Speech.where(code: access_code).first.content
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
end
