class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.text :email
      t.text :firstname
      t.text :lastname
      t.text :company
      t.text :phone
      t.text :address
      t.text :city
      t.text :state
      t.text :country
      t.text :zip

      t.timestamps
    end
  end
end
