class CreateQrInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :qr_infos do |t|
      t.integer :numbers
      t.string :location, limit: 250
      t.string :email, limit: 200
      t.text :qr_code
      t.integer :ticket_used, default: 0
      t.column :status, "ENUM('active', 'inactive', 'deleted')", default: "active"
      t.timestamps
    end
  end
end
