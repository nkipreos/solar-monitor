class CreateRemoteDevices < ActiveRecord::Migration
  def change
    create_table :remote_devices do |t|
      t.references :account, index: true
      t.string :name
      t.string :unique_id
      t.string :location_name
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6

      t.timestamps
    end
  end
end
