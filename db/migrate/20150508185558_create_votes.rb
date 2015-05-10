class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value
      t.integer :user_id
      t.integer :votable_id
      t.string :votable_type

      t.timestamps null: false
    end

    add_foreign_key :votes, :users
    add_index :votes, [:votable_id, :votable_type]
  end
end
