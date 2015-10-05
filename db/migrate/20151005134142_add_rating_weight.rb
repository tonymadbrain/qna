class AddRatingWeight < ActiveRecord::Migration
  def change
    create_table :rating_weight do |t|
      t.string :name
      t.integer :weight
    end
  end
end
