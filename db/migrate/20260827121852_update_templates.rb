class UpdateTemplates < ActiveRecord::Migration[8.1]
  def change
    rename_column :templates, :content, :template

    add_column :templates, :name, :string
    add_column :templates, :instructions_de, :text
    add_column :templates, :instructions_en, :text
    add_column :templates, :description_de, :text
    add_column :templates, :description_en, :text
  end
end
