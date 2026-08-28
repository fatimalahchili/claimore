class AddMetadataColumnToTemplates < ActiveRecord::Migration[8.1]
  def change
    add_column :templates, :metadata, :jsonb, default: {}, null: false
  end
end
