class AddColumnEventIdToQrInfo < ActiveRecord::Migration[7.2]
  def change
    add_column :qr_infos, :event_id, :bigint, limit: 20
  end
end
