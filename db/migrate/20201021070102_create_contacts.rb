class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.text :name
      t.text :email
      t.text :phone
      t.text :subject
      t.text :message

      t.timestamps
    end
  end
end
