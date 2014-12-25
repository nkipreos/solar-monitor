class CreateUserAccountRelations < ActiveRecord::Migration
  def change
    create_table :user_account_relations do |t|
      t.references :user, index: true
      t.references :account, index: true
      t.string :relation_type

      t.timestamps
    end
  end
end
