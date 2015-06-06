class CreateSubscribeLists < ActiveRecord::Migration
  def change
    create_table :subscribe_lists do |t|
      t.references :user, index: true
      t.references :question, index: true

      t.timestamps null: false
    end

    add_foreign_key :subscribe_lists, :users
    add_foreign_key :subscribe_lists, :questions
  end
end
