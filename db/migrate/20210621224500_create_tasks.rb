class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :owner
      t.string :title
      t.text :description
      t.string :status
      t.string :visibility

      t.timestamps
    end
  end
end
