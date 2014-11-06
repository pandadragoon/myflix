class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :recipient_name
      t.string :recipient_table
      t.string :token
      t.integer :inviter_id
      t.text :message
      t.timestamps
    end
  end
end
