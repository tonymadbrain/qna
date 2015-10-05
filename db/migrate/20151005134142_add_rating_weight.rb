class AddRatingWeight < ActiveRecord::Migration
  def change
    create_table :rating_weights do |t|
      t.string :name
      t.integer :weight
    end
  end
end
