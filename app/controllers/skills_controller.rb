class SkillsController < ApplicationController  
  skip_before_action :verify_authenticity_token
  def index
  end
  
  def root
    p "in SkillsController root method"
    input = AlexaRubykit.build_request(params)
    output = AlexaRubykit::Response.new
    session_end = true
    message = "There was an error." # unknown thing happened
    device_id =  params["context"]["System"]["device"]["deviceId"]
    voice_user_id = params["context"]["System"]["user"]["userId"]
    session_articles = Array.new
    
    # Constants
    intro_music = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> <break strength="x-strong" />'
    message_end_music = "<audio src='soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_outro_01'/>"
    outro_music = "<audio src='soundbank://soundlibrary/musical/amzn_sfx_drum_comedy_03'/>"
    
    closing_message = "<break strength='x-strong' /> Thats it for now"

    first_time_welcome_message = 'Welcome to voice reader! <break strength="x-strong" /> 
                                  if you have an access code, tell me your code to get started <break strength="strong" /> 
                                  or <break strength="strong" />
                                  want to see how it works <break strength="strong" /> say give me a demo';
    
    launch_intent_reprompt_message = 'say your access code to get started <break strength="strong" /> 
                                      or <break strength="strong" /> want to see how it works <break strength="strong" /> 
                                      say give me a demo'
                                      
    demo_message = "Hello, I\'m glad to help you to understand the skill better. <break strength='strong' /> 
                    Lets say, you are subscribed for the campaign <break strength='x-strong' />  
                    which has an access code 1234. <break strength='x-strong' /> Then you can listen to the articles as follows
                    <break strength='strong' /> #{intro_music} Welcome! you have new articles <break strength='strong' /> 
                    #{message_end_music} Sports Announcement from sunlake academy <break strength='strong' /> 
                    All 2nd graders must join the early sports competition <break strength='strong' /> 
                    which is scheduled to take place on Nov 15th 2020 <break strength='strong' /> 
                    If any questions or concerns please contact Ms. Marci Leonard at marci at sunlakeacademy dot org. 
                    #{closing_message} <break strength='x-strong' /> #{outro_music} if you have an access code 
                    <break strength='strong' /> tell me your code to get started or say stop or cancel to exit"
    
    demo_reprompt_message = 'Tell me your access code to get started <break strength="strong" /> or <break strength="strong" /> 
                            say bye to exit'
    
    welcome_message_one_campaign = 'Hello! welcome back to voice reader <break strength="x-strong" /> 
                                    There are new articles available <break strength="x-strong" /> 
                                    If you want to listen them, say play articles for access code <break strength="x-strong" /> 
                                    or <break strength="x-strong" /> If you have new code, 
                                    tell me your access code to get started'
    
    welcome_message_more_campaign = 'Hello! welcome back to voice reader <break strength="x-strong" />
                                    There are serveral new articles from the campaigns. <break strength="x-strong" />  
                                    If you want to play/listen say "Play" or "next" to goto next articles. <break strength="x-strong" /> 
                                    If you forgot them, don\'t hesitate to ask HELP to retrieve them. <break strength="x-strong" /> 
                                    Tell me your access code to get started.'
    
    prompt_next_message = 'Do you want to listen to the next one? <break strength="x-strong" />'
    
    
    
    case input.type
    when "LAUNCH_REQUEST"
      audiance = Audiance.find_by_voice_user_id(voice_user_id)
      count = Subscription.where(audiance_id: audiance.id).count unless audiance.blank?
      # FIRST TIME USER
      #if Audiance.check_device_exists(device_id).blank?
      if Audiance.check_user_id_exists(voice_user_id).blank?
        message = "#{intro_music} <break strength='strong' /> #{first_time_welcome_message}"
        reprompt_message = launch_intent_reprompt_message
        session_end = false
      else
        if count<=1
          message = "#{intro_music} <break strength='strong' /> #{welcome_message_one_campaign}" 
          session_end = false         
        elsif count>1
          message = "#{intro_music} <break strength='strong' /> #{welcome_message_more_campaign}" 
          session_end = false                   
        end
      end
    when "INTENT_REQUEST"
      case input.name
      when 'AccessCode'   
        access_code = input.slots["access_code"]["value"]
        if AccessCode.pluck(:code).include?access_code.to_i
          access_code_id = AccessCode.where(code: access_code).last.id
          vc_admin_id = AccessCode.where(code: access_code).last.user_id
          audiance = Audiance.create(voice_user_id: voice_user_id, device_id: device_id)
          subscription = Subscription.create(audiance_id: audiance.id, access_code_id: access_code_id)
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
      when 'AMAZON.HelpIntent'
        message = 'Hello, you can ask me to play articles for an access code <break strength="strong" /> in which I can help you to hear your articles <break strength="strong" /> or <break strength="strong" /> say cancel to exit the skill'
        session_end = false
      when 'AMAZON.FallbackIntent'
        message = 'I am sorry, I cant help you with that. <break strength="strong" /> I can help you to play articles for an access code or list access codes. <break strength="strong" /> What can I help you with?'
        session_end = false
      when 'helloIntent'
        message = 'Hello, you can ask me to play articles for an access code in which I can help you to hear your articles'
        session_end = false
      when 'DemoIntent'
        message = demo_message
        reprompt_message = 
        session_end = false
      when 'AMAZON.YesIntent'
        if params[:session][:attributes][:articles].blank?
          message = "<break strength='x-strong' /> what's the access code"
        else
          published_articles = params[:session][:attributes][:articles] 
          published_articles.each do |published_article|
            content = published_article["content"]
            article_title = !published_article["title"].blank? ? published_article["title"] : ''
            article_intro = !published_article["intro"].blank? ? published_article["intro"] : ''
            article_outro = !published_article["outro"].blank? ? published_article["outro"] : ''
            article_text = published_articles.size == 1 ? "article" : "articles"
            message = "<break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /> #{article_intro} <break strength='x-strong' /><break strength='x-strong' /> #{article_title} <break strength='x-strong' /><break strength='x-strong' /> #{content.gsub!(/[!@#$%ˆ&*()<>]|(http|ftp|https)?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|$!:,.;]*/, ' ') || content} <break strength='x-strong' /><break strength='x-strong' /> #{article_outro} <break strength='x-strong' /><break strength='x-strong' /> #{message_end_music} <break strength='x-strong' /><break strength='x-strong' /> #{closing_message} <break strength='x-strong' /><break strength='x-strong' /> #{outro_music}";
          end
        end
      when 'AMAZON.NoIntent'
        message = 'Okay see you later' 
      when "SESSION_ENDED_REQUEST"
        # it's over
        message = 'Bye'
        
        #New intents for Add, Play and list articles
      when 'AddCampaignIntent'
        access_code = input.slots["campaign_code"]["value"]
        access_code_id = AccessCode.where(code: access_code).last.id
        if AccessCode.pluck(:code).include? access_code.to_i
          audiance = Audiance.create(voice_user_id: voice_user_id)
          device = Device.create(audiance_id:  audiance.id, device_id: device_id)
          subscription = Subscription.create(audiance_id: audiance.id, access_code_id: access_code_id)
          unless subscription.blank?
            message = "Congratulations, your campaign was added successfully. <break strength='strong' /> Say read or play articles for #{access_code}"
          else
            message = 'Sorry i can\'t add your access code. Try with another access code exists in voice reader'
          end
        else
          message = 'Sorry i can\'t recognize the access code. Ensure the access code available in voice reader and try with that';
          reprompt_message = 'Try with another access code exists in voice reader'
          session_end = false
        end  
        reprompt_message = ''
        session_end = false
        # if access_code_id.blank?
        #   message = 'Sorry i can\'t recognize the access code. Ensure the access code available in voice reader studio and try with that';
        #   reprompt_message = 'Try with another access code exists in voice reader studio'
        #   session_end = false
        # else
        #   intro_speech = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> Campaign added successfully. <break strength="strong" />'
        # end
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
        voice_user_id = params["context"]["System"]["user"]["userId"]
        audiances = Audiance.where(voice_user_id: voice_user_id)
        access_code_arr = Array.new
        published_articles = ""
        intro_speech = '<audio src="soundbank://soundlibrary/ui/gameshow/amzn_ui_sfx_gameshow_intro_01"/> Hello! welcome to voice reader. Here are latest articles <break strength="strong" />'
        unless audiances.blank?
          audiances.each do |audiance|
            access_code_arr << audiance.access_code_id
          end
        end
        access_codes = AccessCode.where(id: access_code_arr).order('id DESC')
        access_codes.each do |access_code|
			    acsm = AccessCodeSpeechMap.where(access_code_id: access_code.id)
			    speech_ids = acsm.map{|acsm| acsm.speech_id}
			    published_articles = Speech.where(id: speech_ids, published: true).order('updated_at DESC')
        end
        published_articles.each_with_index do |speech, indx|
          if indx<2
            
            intro_speech << speech.title
            
            intro_speech << speech.content
          end
          intro_speech << message_end_music
        end
        reprompt_message = ''
        session_end = true
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
      @access_codes = AccessCode.all.order('id DESC')
    else
      @access_codes = AccessCode.where(user_id: current_user.id).order('id DESC')
    end
  end


end #class ends here