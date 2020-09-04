class CreateSubscriptionCancellationFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :subscription_cancellation_feedbacks do |t|
      t.timestamps

      t.timestamp :subscribed_at
      t.text :reason
    end
  end
end
