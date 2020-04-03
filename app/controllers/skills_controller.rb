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
          message = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> Hello! welcome to voice chimp <break strength="strong" /> Please say your access code to get started'
          reprompt_message = 'Please say your access code to get started'
          session_end = false
        else
          intro_speech = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> Hello! welcome back to voice chimp <break strength="strong" />'
          reprompt_message = ''
          session_end = false
          access_code_id = Audiance.check_device_exists(device_id).last.access_code_id
          # content = AccessCodeSpeechMap.where(access_code_id: access_code_id).last.speech.content
          # 21/03/2020 - Added by Jude to fetch the latest published content based on the access code
          acsm = AccessCodeSpeechMap.where(access_code_id: access_code_id)   
          speech_ids = acsm.map{|acsm| acsm.speech_id}
          published_article = Speech.where(id: speech_ids, published: true).order('updated_at').last
          content = published_article.content
          article_title = published_article.title
          intro_music = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_outro_01"/>';

          article_intro = published_article.intro
          article_outro = published_article.outro

          # message = "Hello! welcome to voice chimp. Here is your latest article. #{content}"; 
          if content.blank?
            message = 'Sorry! I couldn\'t find any content avaiable for the code that you are asking'
          else
            if article_title.blank?
              message = intro_speech << "#{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='strong' /> Thats all for the day. Stay tuned<break strength='strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
              session_end = false
            else
              if article_intro.blank? && article_outro.blank?
                message = intro_speech << "#{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                session_end = false
              elsif !article_intro.blank? && article_outro.blank?
                message = intro_speech << "#{intro_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                session_end = false
              elsif article_intro.blank? && !article_outro.blank?
                message = intro_speech << "#{intro_music} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                session_end = false
              elsif !article_intro.blank? && !article_outro.blank?
                message = intro_speech << "#{intro_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro}  <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                session_end = false
              end
            end
          end
        end  
      when "INTENT_REQUEST"
        case input.name
        when 'AccessCode'   
          access_code = input.slots["access_code"]["value"]   
          # message = "You said, #{given}."
          if AccessCode.pluck(:code).include?access_code.to_i
          # if access_code == '9964'
            access_code_id = AccessCode.where(code: access_code).last.id
            vc_admin_id = AccessCode.where(code: access_code).last.user_id
            Audiance.create(voice_user_id: voice_user_id, device_id: device_id, user_id:vc_admin_id, access_code_id: access_code_id)
            # article_title = AccessCodeSpeechMap.where(access_code_id: access_code_id).last.speech.title
            # content = AccessCodeSpeechMap.where(access_code_id: access_code_id).last.speech.content
            
            # 21/03/2020 - Added by Jude to fetch the latest published content based on the access code
            acsm = AccessCodeSpeechMap.where(access_code_id: access_code_id)   
            speech_ids = acsm.map{|acsm| acsm.speech_id}
            published_article = Speech.where(id: speech_ids, published: true).order('updated_at').last
            content = published_article.content
            article_title = published_article.title
            intro_music = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_outro_01"/>';
  
            article_intro = published_article.intro
            article_outro = published_article.outro
            if content.blank?
              message = 'Sorry! I couldn\'t find any content avaiable for the code that you are asking'
            else
              if article_title.blank?
                message = "#{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='strong' /> Thats all for the day. Stay tuned<break strength='strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                session_end = false
              else
                if article_intro.blank? && article_outro.blank?
                  message = intro_speech << "#{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                  session_end = false
                elsif !article_intro.blank? && article_outro.blank?
                  message = intro_speech << "#{intro_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                  session_end = false
                elsif article_intro.blank? && !article_outro.blank?
                  message = intro_speech << "#{intro_music} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                  session_end = false
                elsif !article_intro.blank? && !article_outro.blank?
                  message = intro_speech << "#{intro_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro}  <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                  session_end = false  
                end
              end
            end
          else
            message = 'Sorry i can\'t recognize the access code. Ensure the access code available in voice chimp studio and try with that';
            reprompt_message = 'Try with another access code exists in voice chimp studio'
            session_end = false
          end
        when 'setup_campaign'
          code = input.slots["access_code"]["value"]
          unless code.blank?
            access_code_id = AccessCode.where(code: code).last.id
            if access_code_id.blank?
              message = 'Sorry i can\'t recognize the access code. Ensure the access code available in voice chimp studio and try with that';
              reprompt_message = 'Try with another access code exists in voice chimp studio'
              session_end = false
            else
              acsm = AccessCodeSpeechMap.where(access_code_id: access_code_id)   
              speech_ids = acsm.map{|acsm| acsm.speech_id}
              published_article = Speech.where(id: speech_ids, published: true).order('updated_at').last
              content = published_article.content
              article_title = published_article.title
              intro_music = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_outro_01"/>';
    
              article_intro = published_article.intro
              article_outro = published_article.outro
              if content.blank?
                message = 'Sorry! I couldn\'t find any content avaiable for the code that you are asking'
              else
                if article_title.blank?
                  message = "#{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='strong' /> Thats all for the day. Stay tuned<break strength='strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                  session_end = false
                else
                  if article_intro.blank? && article_outro.blank?
                    message = intro_speech << "#{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                    session_end = false
                  elsif !article_intro.blank? && article_outro.blank?
                    message = intro_speech << "#{intro_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                    session_end = false
                  elsif article_intro.blank? && !article_outro.blank?
                    message = intro_speech << "#{intro_music} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                    session_end = false
                  elsif !article_intro.blank? && !article_outro.blank?
                    message = intro_speech << "#{intro_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro}  <break strength='x-strong' /><break strength='x-strong' /> Thats it for now. <break strength='x-strong' /> <audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>";
                    session_end = false  
                  end
                end
              end
            end
          else
            reprompt_message = 'Try with access code to setup'
            session_end = false
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

      card = {
        "type": "Standard",
        "title": "Voice Chimp",
        "subtitle": "listen to your email campaigns & newsletters",
        "text": "Listen to the email campaigns & newsletters, anytime and anywhere. This is not about podcasting`",
        "image": {
          "smallImageUrl": "https://www.oredein.com/alexa/abc/images/small_card.png",
          "largeImageUrl": "https://www.oredein.com/alexa/abc/images/small_card.png"
        }
      }
      output.add_speech(message,true) unless message.blank?
      output.add_reprompt(reprompt_message, true) unless reprompt_message.blank?
      #output.add_card(type = 'Simple', title = "Voice Chimp", subtitle = "listen to your email campaigns & newsletters", content = "Listen to the email campaigns & newsletters, anytime and anywhere. This is not about podcasting")
      output.add_hash_card(card)
      render json: output.build_response(session_end)
    end

    protected

    def get_content_by_access_code access_code
      
    end

end



