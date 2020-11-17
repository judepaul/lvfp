class SkillsController < ApplicationController  
  skip_before_action :verify_authenticity_token
  def index
  end
  
  def root
    p "in SkillsController root method"
    p params
    input = AlexaRubykit.build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error." # unknown thing happened
    device_id =  params["context"]["System"]["device"]["deviceId"]
    voice_user_id = params["context"]["System"]["user"]["userId"]
    session_articles = Array.new
    
    # Constants
    intro_music = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> <break strength="x-strong" />'
    first_time_welcome_message = 'Hello! welcome to voice reader <break strength="x-strong" /><break strength="x-strong" /> Please say your access code to get started <break strength="x-strong" />'
    welcome_message = 'Hello! welcome back to voice reader <break strength="x-strong" />'
    launch_intent_reprompt_message = 'Please say your access code to get started <break strength="x-strong" />'
    prompt_next_message = 'Do you want to listen to the next one? <break strength="x-strong" />'
    message_end_music = "<audio src='soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_outro_01'/>"
    closing_message = "<break strength='x-strong' /> Thats it for now"
    outro_music = "<audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>"
    case input.type
    when "LAUNCH_REQUEST"
      if Audiance.check_device_exists(device_id).blank?
        message = "#{intro_music} <break strength='strong' /> #{first_time_welcome_message}"
        reprompt_message = launch_intent_reprompt_message
        session_end = false
      else
        intro_speech = "#{intro_music} <break strength='strong' /> #{welcome_message}"
        reprompt_message = ''
        session_end = false
        access_code_id = Audiance.check_device_exists(device_id).last.access_code_id
        acsm = AccessCodeSpeechMap.where(access_code_id: access_code_id)
        speech_ids = acsm.map{|acsm| acsm.speech_id}
        published_articles = Speech.where(id: speech_ids, published: true).order('updated_at DESC').first(2)
        if published_articles.blank?
          message = 'Sorry! I couldn\'t find any article avaiable for the code that you are asking'
        else
          published_articles.each do |published_article|
            content = published_article.content
            article_title = !published_article.title.blank? ? published_article.title : ''
            article_intro = !published_article.intro.blank? ? published_article.intro : ''
            article_outro = !published_article.outro.blank? ? published_article.outro : ''
            article_text = published_articles.size == 1 ? "article" : "articles" 
            if published_articles.size == 2
              # Add prompt message (Do you want to read the next article) for the first article
              if published_article == published_articles.first
                message = intro_speech << "You have #{published_articles.size} new #{article_text} <break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{prompt_next_message}";
                session_end = false
              else
                # Add 2nd article into session to keep reading based on user's confirmation
                session_articles << published_article
              end
            else
              # If published_articles.size == 1 then no need to add the prompt message
              message = intro_speech << "You have #{published_articles.size} new #{article_text} <break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /><break strength='x-strong' />  #{closing_message}  <break strength='x-strong' /><break strength='x-strong' /> #{outro_music}";
              session_end = false
            end
          end
        end
      end
    when "INTENT_REQUEST"
      case input.name
      when 'AccessCode'   
        access_code = input.slots["access_code"]["value"]   
        if AccessCode.pluck(:code).include?access_code.to_i
          access_code_id = AccessCode.where(code: access_code).last.id
          vc_admin_id = AccessCode.where(code: access_code).last.user_id
          Audiance.create(voice_user_id: voice_user_id, device_id: device_id, user_id:vc_admin_id, access_code_id: access_code_id)
          # 21/03/2020 - Added by Jude to fetch the latest published content based on the access code
          acsm = AccessCodeSpeechMap.where(access_code_id: access_code_id)
          speech_ids = acsm.map{|acsm| acsm.speech_id}
          published_articles = Speech.where(id: speech_ids, published: true).order('updated_at DESC').first(2)
          if published_articles.blank?
            message = 'Sorry! I couldn\'t find any article avaiable for the code that you are asking'
          else
            published_articles.each do |published_article|
              content = published_article.content
              article_title = !published_article.title.blank? ? published_article.title : ''
              article_intro = !published_article.intro.blank? ? published_article.intro : ''
              article_outro = !published_article.outro.blank? ? published_article.outro : ''
              article_text = published_articles.size == 1 ? "article" : "articles" 
              if published_article == published_articles.first
                message = "You have #{published_articles.size} new #{article_text} <break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{prompt_next_message}";
                reprompt_message = prompt_next_message
                session_end = false
              else
                session_articles << published_article
              end
            end
          end
        else
          message = 'Sorry i can\'t recognize the access code. Ensure the access code available in voice reader studio and try with that';
          reprompt_message = 'Try with another access code exists in voice reader studio'
          session_end = false
        end
      when 'AMAZON.CancelIntent'
        message = 'Okay see you later'
      when 'AMAZON.StopIntent'
        message = 'Okay see you later'
      when 'helloIntent'
        message = 'Hello, Awesome you are in custom intent handler. Say stop or cancel to exist'
        session_end = false
      when 'AMAZON.YesIntent'
        published_articles = params[:session][:attributes][:articles] unless params[:session][:attributes][:articles].blank?
        published_articles.each do |published_article|
          content = published_article["content"]
          article_title = !published_article["title"].blank? ? published_article["title"] : ''
          article_intro = !published_article["intro"].blank? ? published_article["intro"] : ''
          article_outro = !published_article["outro"].blank? ? published_article["outro"] : ''
          article_text = published_articles.size == 1 ? "article" : "articles"
          message = "<break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /><break strength='x-strong' /> #{closing_message} <break strength='x-strong' /><break strength='x-strong' /> #{outro_music}";
        end
      when 'AMAZON.NoIntent'
        message = 'Okay see you later' 
      when "SESSION_ENDED_REQUEST"
        # it's over
        message = 'Bye'
        
      #New intents for Play and list articles
      when 'PlayIntent'
        code = input.slots["access_code"]["value"]
	      unless code.blank?
		      access_code_id = AccessCode.where(code: code).last.id
		      reprompt_message = ''
		      session_end = false
		      if access_code_id.blank?
			      message = 'Sorry i can\'t recognize the access code. Ensure the access code available in voice reader studio and try with that';
			      reprompt_message = 'Try with another access code exists in voice reader studio'
			      session_end = false
		      else
			      intro_speech = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> Hello! welcome to voice reader <break strength="strong" />'
			      acsm = AccessCodeSpeechMap.where(access_code_id: access_code_id)
			      speech_ids = acsm.map{|acsm| acsm.speech_id}
			      published_articles = Speech.where(id: speech_ids, published: true).order('updated_at DESC').first(2)
			      if published_articles.blank?
				      message = 'Sorry! I couldn\'t find any article avaiable for the code that you are asking'
			      else
				      published_articles.each_with_index do |published_article, indx|
					      content = published_article.content
					      article_title = !published_article.title.blank? ? published_article.title : ''
					      article_intro = !published_article.intro.blank? ? published_article.intro : ''
					      article_outro = !published_article.outro.blank? ? published_article.outro : ''
					      article_text = published_articles.size == 1 ? "article" : "articles"
                if indx < published_articles.size
                  # Add prompt message (Do you want to read the next article) for the first article
                  unless published_article == published_articles.last
                    message = intro_speech << "You have #{published_articles.size} new #{article_text} <break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{prompt_next_message}";
                    reprompt_message = prompt_next_message
                    session_end = false
                  else
                    # Add 2nd article into session to keep reading based on user's confirmation
                    session_articles << published_article
                  end
                else
                  # If published_articles.size == 1 then no need to add the prompt message
                  message = intro_speech << "You have #{published_articles.size} new #{article_text} <break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /><break strength='x-strong' />  #{closing_message}  <break strength='x-strong' /> #{outro_music}";
                  session_end = false
                end
                indx = indx+1
				      end
			      end
		      end
	      else
		      reprompt_message = 'Try with access code to setup'
		      session_end = false
	      end
      
      when 'ListAccessCode'
        p "in ListAccessCode"
	      access_codes = AccessCode.all
	      reprompt_message = ''
	      session_end = false
        intro_speech = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> Hello! welcome to voice reader. Here are the list of access codes <break strength="strong" />'
        access_codes.each_with_index do |access_code, indx|
                  intro_speech << "#{access_code.code} <break strength='x-strong' />";
                end
        message = "#{intro_speech} <break strength='x-strong' /> #{outro_music}";
        session_end = false
        
      when 'setup_campaign'
        code = input.slots["access_code"]["value"]
	      unless code.blank?
		      access_code_id = AccessCode.where(code: code).last.id
		      reprompt_message = ''
		      session_end = false
		      if access_code_id.blank?
			      message = 'Sorry i can\'t recognize the access code. Ensure the access code available in voice reader studio and try with that';
			      reprompt_message = 'Try with another access code exists in voice reader studio'
			      session_end = false
		      else
			      intro_speech = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> Hello! welcome to voice reader <break strength="strong" />'
			      acsm = AccessCodeSpeechMap.where(access_code_id: access_code_id)
			      speech_ids = acsm.map{|acsm| acsm.speech_id}
			      published_articles = Speech.where(id: speech_ids, published: true).order('updated_at DESC').first(2)
			      if published_articles.blank?
				      message = 'Sorry! I couldn\'t find any article avaiable for the code that you are asking'
			      else
				      published_articles.each do |published_article|
					      content = published_article.content
					      article_title = !published_article.title.blank? ? published_article.title : ''
					      article_intro = !published_article.intro.blank? ? published_article.intro : ''
					      article_outro = !published_article.outro.blank? ? published_article.outro : ''
					      article_text = published_articles.size == 1 ? "article" : "articles"
                if published_articles.size == 2
                  # Add prompt message (Do you want to read the next article) for the first article
                  if published_article == published_articles.first
                    message = intro_speech << "You have #{published_articles.size} new #{article_text} <break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{prompt_next_message}";
                    reprompt_message = prompt_next_message
                    session_end = false
                  else
                    # Add 2nd article into session to keep reading based on user's confirmation
                    session_articles << published_article
                  end
                else
                  # If published_articles.size == 1 then no need to add the prompt message
                  message = intro_speech << "You have #{published_articles.size} new #{article_text} <break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /><break strength='x-strong' />  #{closing_message}  <break strength='x-strong' /> #{outro_music}";
                  session_end = false
                end
				      end
			      end
		      end
	      else
		      reprompt_message = 'Try with access code to setup'
		      session_end = false
	      end
      end # inner when ends here
    end # When ends here
    card = {
      "type": "Standard",
      "title": "voice reader",
      "subtitle": "listen to your email campaigns & newsletters",
      "text": "Listen to the email campaigns & newsletters, anytime and anywhere. This is not about podcasting",
      "image": {
        "smallImageUrl": "https://fish-world.s3.amazonaws.com/voice-chimp-720-480.png",
        "largeImageUrl": "https://fish-world.s3.amazonaws.com/voice-chimp-1200-800.png"
      }
    }

    
    output.add_speech(message,true) unless message.blank?
    output.add_reprompt(reprompt_message, true) unless reprompt_message.blank?
    #output.add_card(type = 'Simple', title = "voice reader", subtitle = "listen to your email campaigns & newsletters", content = "Listen to the email campaigns & newsletters, anytime and anywhere. This is not about podcasting")
    output.add_hash_card(card)
    output.add_session_attribute("articles", session_articles)
    render json: output.build_response(session_end)
  end #root ends here


  def published_skill_details
    if current_user.role == "super_vc_admin"
      @access_codes = AccessCode.all.order('updated_at DESC')
    else
      @access_codes = AccessCode.where(user_id: current_user.id).order('updated_at DESC')
    end
  end


end #class ends here