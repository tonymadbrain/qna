class AddColumnsToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :confirm_code, :string
    add_column :identities, :email, :string
  end
end
