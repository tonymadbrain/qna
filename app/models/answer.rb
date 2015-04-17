class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable

  validates :body, presence: true, length: { maximum: 200 }
  validates :user, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order(best: :desc).order(created_at: :asc) }

  def make_best
    question.answers.update_all(best: false)
    update(best: true)
  end
end
