class AddStatusToTenants < ActiveRecord::Migration[8.1]
  def change
    add_column :tenants, :status, :string, default: "invited", null: false
    add_index :tenants, :status
  end
end
