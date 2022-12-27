class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :conversation, foreign_key: true
      t.references :user, foreign_key: true
      # booleanは、データ型の一種で true(真) か false(偽) の値を管理する
      # このカラムに nil（無） という余計な情報が入らないようにするために、デフォルト値を指定しておく
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
