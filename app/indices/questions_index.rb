ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes body
  indexes user.email, as: :author, sortable: true
  indexes answers.body, as: :answers
  indexes comments.body, as: :comments

  # attributes
  has user_id, created_at, updated_at
end