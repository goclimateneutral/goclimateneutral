class AddFirstSubscriptionCreatedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_subscription_created_at, :datetime
    add_index :users, :first_subscription_created_at
  end
end
