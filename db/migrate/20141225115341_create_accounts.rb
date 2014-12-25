class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :api_key
      t.string :timezone

      t.timestamps
    end
  end
end
