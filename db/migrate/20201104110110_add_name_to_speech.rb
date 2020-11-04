class AddNameToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :name, :text
  end
end
