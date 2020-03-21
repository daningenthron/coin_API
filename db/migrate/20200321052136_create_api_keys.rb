class CreateApiKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :api_keys do |t|
      t.string :key
      t.string :email
      t.boolean :admin

      t.timestamps
    end
  end
end
