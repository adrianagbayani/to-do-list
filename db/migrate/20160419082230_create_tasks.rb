class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :task_list, index: true, foreign_key: true
      t.string :title
      t.timestamp :due_date

      t.timestamps null: false
    end
  end
end
