class User < ActiveRecord::Base
  has_many :members
  has_many :events, through: :members
  has_many :friendships
  has_many :friends, through: :friendships

 before_save -> { skip_confirmation! }
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
end
