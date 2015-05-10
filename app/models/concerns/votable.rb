module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    votes.create(user: user, value: value)
  end

  def disvote(user)
    votes.where(user: user).delete_all
  end

  def total_votes
    votes.sum :value
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end
end