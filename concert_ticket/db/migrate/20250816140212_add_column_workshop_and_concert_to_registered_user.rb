class AddColumnWorkshopAndConcertToRegisteredUser < ActiveRecord::Migration[7.2]
  def change
    add_column :registered_users, :workshop, :integer, limit: 2
    add_column :registered_users, :concert, :integer, limit: 2
  end
end
