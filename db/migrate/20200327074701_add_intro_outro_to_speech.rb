class AddIntroOutroToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :intro, :text
    add_column :speeches, :outro, :text
  end
end
