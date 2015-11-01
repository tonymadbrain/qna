class AddColumnRatingForUser < ActiveRecord::Migration
  def change
    add_column :users, :rating, :integer
  end
end
