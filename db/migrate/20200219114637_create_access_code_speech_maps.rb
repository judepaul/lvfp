class CreateAccessCodeSpeechMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :access_code_speech_maps do |t|
      t.references :access_code, foreign_key: true
      t.references :speech, foreign_key: true

      t.timestamps
    end
  end
end
