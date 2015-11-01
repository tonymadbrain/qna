class AddRatingAction < ActiveRecord::Migration
  def change
    create_table :rating_actions do |t|
      t.references :rating_weight, index: true
      t.references :user, index: true
      t.integer :count

      t.timestamps null: false
    end

    add_foreign_key :rating_actions, :rating_weights
    add_foreign_key :rating_actions, :users
    # add_index :rating_actions, [:rating_weight, :user]
  end
end
