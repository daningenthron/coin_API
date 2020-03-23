class FixColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :api_keys, :key, :key_str
  end
end
