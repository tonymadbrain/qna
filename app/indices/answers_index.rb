ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body

  has user_id, created_at, updated_at
end