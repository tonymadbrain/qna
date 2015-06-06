class Question < ActiveRecord::Base
  include Votable
  include Attachable
  
  has_many :answers, dependent: :destroy
  has_many  :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable 
  has_many :subscribe_lists, dependent: :destroy
  has_many :subscribers, class_name: 'User', through: :subscribe_lists
  belongs_to :user

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, presence: true, length: { maximum: 1400 }
  validates :user, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |attrib| attrib['file'].nil? }, allow_destroy: true

  scope :created_yesterday, -> { where(created_at: Time.zone.now.yesterday.all_day) }

  after_create :subscribe_author

  def subscribe(user)
    self.subscribers << user unless has_subscribed? user
  end

  def unsubscribe(user)
    self.subscribers.delete(user) if has_subscribed? user
  end

  def has_subscribed?(user)
    subscribers.include? user
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
