class CreateStreamData < ActiveRecord::Migration
  def change
    create_table :stream_data do |t|
      t.references :stream, index: true
      t.float :value

      t.timestamps
    end
  end
end
