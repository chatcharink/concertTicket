class AddAuthTokenToQrInfo < ActiveRecord::Migration[7.2]
  def change
    add_column :qr_infos, :auth_token, :string
    add_index :qr_infos, :auth_token, unique: true
  end
end
