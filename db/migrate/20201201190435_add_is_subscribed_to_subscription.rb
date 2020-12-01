class AddIsSubscribedToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :is_subscribed, :boolean
  end
end
