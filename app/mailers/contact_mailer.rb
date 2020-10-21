class ContactMailer < ApplicationMailer
  
  def contact_notification_email_to_admin
      @contact_detail = params[:contact]
      name = @contact_detail.name
      admin_email = "hello@launchvoicereader.com"
      mail(to: admin_email, subject: "LVR - Portal Contact form submitted by - #{name}")
    end
    
end
