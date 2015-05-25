class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user

  has_many  :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1400 }
  validates :user, presence: true

  default_scope { order(best: :desc).order(created_at: :asc) }

  def make_best
    question.answers.update_all(best: false)
    update(best: true)
  end
end
