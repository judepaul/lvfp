module SessionsHelper
  def random_text
    text_arr=Array.new
    text_arr=["Make your subscribers listen to your emails or newsletters, anytime and anywhere.",
              "Do you send email campaigns?<br/> Your subscribers can listen&#42; to your content anytime and anywhere."
            ].sample
  end
end
