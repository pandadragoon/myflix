class FixColumnNameInvitations < ActiveRecord::Migration
  def change
    rename_column :invitations, :recipient_table, :recipient_email
  end
end
