class User < ActiveRecord::Base
  has_many :members
  has_many :events, through: :members
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user 
  has_many :friendships
  has_many :friends, through: :friendships

  validates :username, length: { minimum: 6 }
  validates :username, presence: true
  validates :username, uniqueness: true
  validates_format_of :username, with: /\A[a-z0-9_]+\z/

 before_save -> { skip_confirmation! }

  def self.search(search)
    where("username LIKE ?", "%#{search}%").limit(11)
  end

  def contacts
    self.friends.as_json + self.inverse_friends.as_json
  end


  def friend_requests_sent
    result = []
    pending_friendships = Friendship.where(user: self, accepted: false)
    pending_friendships.each { |friendship| result << friendship.friend }
    return result
  end

  def friend_requests_recieved
    result = []
    inverse_pending_friendships = Friendship.where(friend: self, accepted: false)
    inverse_pending_friendships.each { |friendship| result << friendship.user}
    return result
  end


  def log_self
    return self
  end

accepts_nested_attributes_for :members, :events
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :authentication_keys => [:username]
  include DeviseTokenAuth::Concerns::User
end
