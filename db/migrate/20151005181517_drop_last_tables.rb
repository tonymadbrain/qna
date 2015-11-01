class DropLastTables < ActiveRecord::Migration
  def change
    drop_table :rating_actions
    drop_table :rating_weights
  end
end
