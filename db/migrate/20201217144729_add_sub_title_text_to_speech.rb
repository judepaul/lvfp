class AddSubTitleTextToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :sub_title_text, :text
  end
end
