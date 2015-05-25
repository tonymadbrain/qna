class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter] 
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :identitys

  def self.find_for_oauth(auth)
    identity = Identity.where(provider: auth.provider, uid: auth.uid.to_s).first
    return identity.user if identity

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_identity(auth)
    else
      password = Devise.friendly_token[0, 16]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_identity(auth)
    end
    
    user
  end

  def create_identity(auth)
    self.identitys.create(provider: auth.provider, uid: auth.uid)
  end
end
