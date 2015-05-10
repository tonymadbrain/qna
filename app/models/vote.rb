class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: [-1, 1]
end
