class CreateUserContentMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :user_content_maps do |t|
      t.references :user, foreign_key: true
      t.references :speech, foreign_key: true

      t.timestamps
    end
  end
end
