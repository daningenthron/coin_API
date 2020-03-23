class FixTableName < ActiveRecord::Migration[6.0]
  def change
    rename_table :transactions, :txns
  end
end
