class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user, index: true, unique: true
      t.string :type
      t.integer :count

      t.timestamps null: false
    end

    add_foreign_key :ratings, :users
  end
end
