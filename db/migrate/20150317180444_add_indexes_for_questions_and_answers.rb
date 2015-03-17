class AddIndexesForQuestionsAndAnswers < ActiveRecord::Migration
  def change
    add_index :questions, :user_id
    add_index :answers, :user_id
  end
end
