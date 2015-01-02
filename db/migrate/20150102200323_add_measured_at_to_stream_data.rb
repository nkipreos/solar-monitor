class AddMeasuredAtToStreamData < ActiveRecord::Migration
  def change
    add_column :stream_data, :measured_at, :datetime
  end
end
