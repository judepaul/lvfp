class CreateAudiances < ActiveRecord::Migration[5.1]
  def change
    create_table :audiances do |t|
      t.string :voice_user_id
      t.string :device_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
