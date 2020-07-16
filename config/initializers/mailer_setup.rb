require 'net/smtp'

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'seedcube.com',
  :user_name            => 'jude@seedcube.com',
  :password             => 'H8wyQwkI7UPr',
  # :domain               => 'visiontss.com',
  # :user_name            => 'smartadmin@visiontss.com',
  # :password             => 'smartadmin',
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
ActionMailer::Base.asset_host = 'http://localhost:3000'
ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.default_content_type = "text/html"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

if $mailcatcher_enabled
  begin
    smtp = Net::SMTP.start "localhost", 1025
    if smtp.started?
      smtp.quit
      puts ">> WARNING: Found an SMTP server on port 1025"
      puts "            Assuming that it is MockSMTP or MailCatcher..."
      puts ">> Emails WILL be sent to the SMTP server on port 1025"

      # config.action_mailer.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = {
        :address => "localhost",
        :port => 1025
      }
    end
  rescue Errno::ECONNREFUSED
    puts ">> No SMTP server found on port 1025"
    puts ">> Emails will be sent to STDOUT"
  end
end
