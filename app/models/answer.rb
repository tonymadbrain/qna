class Answer < ActiveRecord::Base
  include Attachable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { maximum: 200 }
  validates :user, presence: true

  default_scope { order(best: :desc).order(created_at: :asc) }

  def make_best
    question.answers.update_all(best: false)
    update(best: true)
  end
end
