class CreateSpeeches < ActiveRecord::Migration[5.1]
  def change
    create_table :speeches do |t|
      t.string :code
      t.string :email_address
      t.string :content

      t.timestamps
    end
  end
end
