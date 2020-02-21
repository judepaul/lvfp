class AddIsDeletedToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :is_deleted, :boolean
  end
end
