class AddPhoneNumberToQrInfo < ActiveRecord::Migration[7.2]
  def change
    add_column :qr_infos, :phone_number, :string, limit: 100
  end
end
