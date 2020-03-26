class AddFromAndSentDateToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :email_from, :text
    add_column :speeches, :email_sent_date, :datetime
  end
end
