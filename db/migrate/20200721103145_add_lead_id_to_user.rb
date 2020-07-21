class AddLeadIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :lead, foreign_key: true
  end
end
