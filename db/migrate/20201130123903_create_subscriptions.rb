class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :audiance, foreign_key: true
      t.references :access_code, foreign_key: true

      t.timestamps
    end
  end
end
