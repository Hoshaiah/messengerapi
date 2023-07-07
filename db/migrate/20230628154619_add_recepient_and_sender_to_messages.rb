class AddRecepientAndSenderToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :recipient, polymorphic: true, index: true
    add_reference :messages, :sender, foreign_key: { to_table: :users }
  end
end
