class CreateEmpathies < ActiveRecord::Migration[5.2]
  def change
    create_table :empathies do |t|
      t.integer :user_id
      t.integer :question_id

      t.timestamps
    end
  end
end
