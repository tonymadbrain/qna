class AddMultiplierRating < ActiveRecord::Migration
  def change
    create_table  :multiplier_rating do |t|
      t.string :rating_type
      t.string :multiplier

      t.timestamps null: false
    end
  end
end
