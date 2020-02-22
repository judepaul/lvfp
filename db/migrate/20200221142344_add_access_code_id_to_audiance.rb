class AddAccessCodeIdToAudiance < ActiveRecord::Migration[5.1]
  def change
    add_reference :audiances, :access_code, foreign_key: true
  end
end
