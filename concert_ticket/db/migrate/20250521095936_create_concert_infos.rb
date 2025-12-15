class CreateConcertInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :concert_infos do |t|
      t.string :concert_name
      t.datetime :event_day
      t.integer :is_default, limit: 2
      t.timestamps
    end
  end
end
