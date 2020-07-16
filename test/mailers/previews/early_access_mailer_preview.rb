# Preview all emails at http://localhost:3000/rails/mailers/early_access_mailer
class EarlyAccessMailerPreview < ActionMailer::Preview
    def welcome_email
        access_details = {"reciever_email": "judepaul@seedcube.com", "reciever_name": "Jude Paul"}
        @reciever_email = access_details[:reciever_email]
        @reciever_name = access_details[:reciever_name]
        mail(to: reciever_email, subject: "Welcome to Launch Voice Reader!")
      end
end
