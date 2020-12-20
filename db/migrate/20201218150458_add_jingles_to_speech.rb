class AddJinglesToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :intro_jingle, :text
    add_column :speeches, :title_jingle, :text
    add_column :speeches, :sub_title_jingle, :text
    add_column :speeches, :outro_jingle, :text
    add_column :speeches, :intro_jingle_value, :text
    add_column :speeches, :title_jingle_value, :text
    add_column :speeches, :sub_title_jingle_value, :text
    add_column :speeches, :outro_jingle_value, :text
    
  end
end
