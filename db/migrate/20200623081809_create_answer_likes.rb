class CreateAnswerLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_likes do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps
    end
  end
end
