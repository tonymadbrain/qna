class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :question, touch: true
  belongs_to :user

  has_many  :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1400 }
  validates :user, presence: true

  default_scope { order(best: :desc).order(created_at: :asc) }

  after_create :report_subscribers

  def make_best
    question.answers.update_all(best: false)
    update(best: true)
  end

  private

  def report_subscribers
    ReportSubscribersJob.perform_later(self)
    # self.question.subscribers.find_each do |subscriber|
    #   ReportMailer.delay.report(subscriber, self)
    # end
  end
end
