class NormalizeClaimStatuses < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL.squish
      UPDATE claims
      SET status = CASE
        WHEN status IN ('resolved', 'archived') THEN 'archived'
        ELSE 'active'
      END
    SQL

    change_column_default :claims, :status, from: nil, to: "active"
  end

  def down
    change_column_default :claims, :status, from: "active", to: nil
  end
end
