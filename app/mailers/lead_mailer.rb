class LeadMailer < ApplicationMailer
    def welcome_email
        lead_details = params[:lead]
        @reciever_email = lead_details[:email]
        @reciever_fname = lead_details[:firstname]
        mail(to: @reciever_email, subject: "Welcome to Launch Voice Reader!")
      end
end
