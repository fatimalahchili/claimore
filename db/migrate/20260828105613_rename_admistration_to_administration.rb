class RenameAdmistrationToAdministration < ActiveRecord::Migration[8.1]
  def change
    rename_table :admistrations, :administrations
  end
end
