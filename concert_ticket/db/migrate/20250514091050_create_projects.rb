class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :project_name, limit: 200
      t.text :description
      t.date :date
      t.column :status, "ENUM('active', 'deleted')"
      t.timestamps
    end
  end
end
