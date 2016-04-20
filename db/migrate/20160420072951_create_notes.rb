class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :task, index: true, foreign_key: true
      t.string :message

      t.timestamps null: false
    end
  end
end
