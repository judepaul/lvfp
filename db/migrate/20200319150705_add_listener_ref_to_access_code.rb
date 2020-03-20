class AddListenerRefToAccessCode < ActiveRecord::Migration[5.1]
  def change
    add_reference :access_codes, :listener, foreign_key: true
  end
end
