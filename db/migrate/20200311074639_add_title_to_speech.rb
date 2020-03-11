class AddTitleToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :title, :text
  end
end
