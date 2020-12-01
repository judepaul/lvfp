class RemoveUserIdFromAudiance < ActiveRecord::Migration[5.1]
  def change
    remove_reference :audiances, :user, foreign_key: true
  end
end
