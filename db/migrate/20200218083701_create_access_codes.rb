class CreateAccessCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :access_codes do |t|
      t.integer :code
      t.string :title
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
