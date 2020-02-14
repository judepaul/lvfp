class CreateSpeeches < ActiveRecord::Migration[5.1]
  def change
    create_table :speeches do |t|
      t.integer :email_code
      t.string :email_address
      t.text :content

      t.timestamps
    end
  end
end
