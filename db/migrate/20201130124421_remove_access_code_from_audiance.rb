class RemoveAccessCodeFromAudiance < ActiveRecord::Migration[5.1]
  def change
    remove_reference :audiances, :access_code, foreign_key: true
  end
end
