class FixColumnNameTxnType < ActiveRecord::Migration[6.0]
  def change
    rename_column :txns, :type, :txn_type
  end
end
