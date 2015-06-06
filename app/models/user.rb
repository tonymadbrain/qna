class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter] 
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :identitys, dependent: :destroy

  scope :all_except, ->(user) { where.not(id: user) }

  attr_accessor :without_password

  def password_required?
    super && !without_password
  end

  def self.find_for_oauth(auth)
    identity = Identity.includes(:user).find_or_create_by(uid: auth.uid, provider: auth.provider)
    return identity.user if identity.user.present?
    
    if auth.info.email.present?
      user = User.find_by(email: auth.info.email)
      unless user.present?
        user = User.new(email: auth.info.email)
        user.without_password = true
        user.save!
      end
      identity.update!(user: user)
      return user
    end
    
    user = User.new
    user.identitys << identity
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.delay.digest(user)
    end
  end
end
