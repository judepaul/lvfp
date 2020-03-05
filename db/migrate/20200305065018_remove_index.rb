class RemoveIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, column: :email, unique: true
  end
end
