class AddEmailPhoneToAudiance < ActiveRecord::Migration[5.1]
  def change
    add_column :audiances, :email, :string
    add_column :audiances, :phone, :string
  end
end
