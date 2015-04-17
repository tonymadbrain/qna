class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 200 }
  validates :user, presence: true

  accepts_nested_attributes_for :attachments
end
