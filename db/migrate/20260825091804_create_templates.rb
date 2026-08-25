class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.text :content

      t.timestamps
    end
  end
end
