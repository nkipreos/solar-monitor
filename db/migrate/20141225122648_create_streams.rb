class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.references :remote_device, index: true
      t.string :stream_type
      t.string :unique_id

      t.timestamps
    end
  end
end
