class InstallNeighborVector < ActiveRecord::Migration[8.1]
  def change
    enable_extension "vector"
  end
end
