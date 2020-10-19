class LeadMailer < ApplicationMailer
    def welcome_email
        lead_details = params[:lead]
        @reciever_email = lead_details[:email]
        @reciever_fname = lead_details[:firstname]
        mail(to: @reciever_email, subject: "Welcome to Launch Voice Reader!")
      end
      
    def lead_notification_email_to_admin
        lead_details = params[:lead]
        @lead_email = lead_details[:email]
        @lead_fname = lead_details[:firstname]
        @lead_lname = lead_details[:lastname]
        admin_email = "hello@launchvoicefirst.com"
        mail(to: admin_email, subject: "New lead from Launch Voice Reader!")
      end
    
end
