class CreateChannelToKnows < ActiveRecord::Migration[7.2]
  def change
    create_table :channel_to_knows do |t|
      t.string :channel_name_th, limit: 200
      t.string :channel_name_en, limit: 200
      t.column :status, "ENUM('active', 'deleted')"
      t.timestamps
    end
  end
end
