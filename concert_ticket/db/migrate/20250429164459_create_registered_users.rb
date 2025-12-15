class CreateRegisteredUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :registered_users do |t|
      t.string :firstname, limit: 150
      t.string :lastname, limit: 150
      t.string :email, limit: 200
      t.string :phone_number, limit: 50
      t.date  :dob
      t.integer :gender, limit: 2
      t.string :country, limit: 150
      t.string :province, limit: 150
      t.string :district, limit: 150
      t.integer :channel_to_know, limit: 5
      t.integer :default_language, limit: 5
      t.bigint :qr_id, limit: 20
      t.column :status, "ENUM('registered', 'participated', 'inactive')"
      t.timestamps
    end
  end
end
