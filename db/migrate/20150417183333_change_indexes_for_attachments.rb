class ChangeIndexesForAttachments < ActiveRecord::Migration
  def change
    remove_index :attachments, :attachmentable_id
    remove_index :attachments, :attachmentable_type

    rename_column :attachments, :attachmentable_id, :attachable_id
    rename_column :attachments, :attachmentable_type, :attachable_type

    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
