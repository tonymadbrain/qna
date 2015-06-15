class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, :user_id, :commentable_id, :commentable_type, presence: true
end
