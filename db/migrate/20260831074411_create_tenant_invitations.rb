class CreateTenantInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :tenant_invitations do |t|
      t.references :property, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :invited_by, null: false, foreign_key: { to_table: :users }
      t.string :role, default: "guest", null: false
      t.string :token, null: false
      t.datetime :accepted_at

      t.timestamps
    end
    add_index :tenant_invitations, :token, unique: true
  end
end
