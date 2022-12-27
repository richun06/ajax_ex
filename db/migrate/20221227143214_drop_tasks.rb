class DropTasks < ActiveRecord::Migration[6.1]
  def change
    drop_table :tasks do |t|
      t.string :title
      t.text :content
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
    end
  end
end
