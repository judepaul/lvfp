class SkillsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def root
        p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      case params['request']['type']
        when 'LaunchRequest'
            #output.add_speech("Hello World")
            #render json: output.build_response(session_end)
            speech_content = Speech.last.content;
            p speech_content;
            render json:  {
  version: "1.0",
  response: {
    outputSpeech: {
      type: "PlainText",
      text: "#{speech_content}"
    },
    shouldEndSession: true
  }
}.to_json
        when 'IntentRequest'
          response = IntentRequest.new.respond(params['request']['intent'])
       end
    end
  
    def respond intent_request
      intent_name = intent_request['name']
    
      Rails.logger.debug { "IntentRequest: #{intent_request.to_json}" }
    
      case intent_name
        when 'AMAZON.StopIntent'
          speech = 'Peace, out.'
        else
          speech = 'I am going to ignore that.'
      end
    
      output = AlexaRubykit::Response.new
      output.add_speech(speech)
      output.build_response(true)
    end
end
