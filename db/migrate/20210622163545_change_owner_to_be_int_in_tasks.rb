class ChangeOwnerToBeIntInTasks < ActiveRecord::Migration[6.1]
  def up
    change_column :tasks, :owner, :integer
  end

  def down
    change_column :tasks, :owner, :string
  end
end
