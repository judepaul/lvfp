class CreateSpeeches < ActiveRecord::Migration[5.1]
  def change
    create_table :speeches do |t|
      t.integer :email_code, :default => 1000
      t.string :email_address
      t.text :content

      t.timestamps
    end
  end
end
