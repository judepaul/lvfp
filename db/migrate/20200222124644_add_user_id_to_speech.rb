class AddUserIdToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_reference :speeches, :user, foreign_key: true
  end
end
