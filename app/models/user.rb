class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name # assuming the user model has a name
      user.gravatar_url = auth.info.image # assuming the user model has an image
    end
  end

  def show_requests
    current_user.inverse_friendships.where(status: false)
  end

  def show_pending
    current_user.friendships.where(status: false)
  end

  def friends
    current_user.friendships.where(status: true)
  end

  def user_friends(user)
    user.friendships.where(status: true)
  end

  def show_mutual_friends(user)
    u1 = user.friendships.find_by(status: true)
    u2 = current_user.friendships.find_by(status: true)
    return if u1.nil? || u2.nil?

    @mutual = u1 if u1.friend_id == u2.friend_id
  end

end


