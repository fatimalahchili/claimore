class RenameTemplateColumnToContent < ActiveRecord::Migration[8.1]
  def change
    rename_column :templates, :template, :content
  end
end
