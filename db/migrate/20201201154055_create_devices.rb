class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.references :audiance, foreign_key: true
      t.string :device_id
      t.string :type
      t.string :location

      t.timestamps
    end
  end
end
