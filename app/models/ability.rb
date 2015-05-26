class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user

    can :destroy, [Question, Answer, Comment], user: user
    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end

    can :vote, [Answer, Question] do |resource|
      user.id != resource.user_id && !resource.voted_by?(user)
    end

    can :disvote, [Answer, Question] do |resource|
      user.id != resource.user_id
    end

    can :make_best, Answer do |answer|
      answer.question.user_id == user.id
    end

  end
end