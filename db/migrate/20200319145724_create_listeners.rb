class CreateListeners < ActiveRecord::Migration[5.1]
  def change
    create_table :listeners do |t|
      t.references :user, foreign_key: true
      t.string :group_name
      t.string :group_code
      t.string :group_title
      t.string :group_description

      t.timestamps
    end
  end
end
