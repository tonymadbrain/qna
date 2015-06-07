ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email

  has created_at, updated_at
end