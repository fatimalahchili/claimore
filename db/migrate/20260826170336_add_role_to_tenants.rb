class AddRoleToTenants < ActiveRecord::Migration[8.1]
  def change
    add_column :tenants, :role, :string, default: "guest", null: false
    add_index :tenants, :role
  end
end
