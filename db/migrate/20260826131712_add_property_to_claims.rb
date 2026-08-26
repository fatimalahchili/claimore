class AddPropertyToClaims < ActiveRecord::Migration[8.1]
  def change
    add_reference :claims, :property, null: false, foreign_key: true
  end
end
