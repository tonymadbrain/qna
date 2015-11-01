class RenameTypeIntoRtypeInRating < ActiveRecord::Migration
  def change
    rename_column :ratings, :type, :r_type
  end
end
