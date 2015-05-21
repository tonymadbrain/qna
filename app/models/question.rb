class Question < ActiveRecord::Base
  include Votable
  include Attachable
  
  has_many :answers, dependent: :destroy
  has_many  :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable 
  belongs_to :user

  validates :title, presence: true, length: { maximum: 140 }
  validates :body, presence: true, length: { maximum: 1400 }
  validates :user, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |attrib| attrib['file'].nil? }, allow_destroy: true
end
