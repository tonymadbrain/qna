class AddIndeOnProviderAndUidForIdentitys < ActiveRecord::Migration
  def change
    add_index :identities, [:provider, :uid]
  end
end
