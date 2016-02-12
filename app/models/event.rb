require 'json'

class Event < ActiveRecord::Base

  has_many :members
  has_many :users, through: :members

  accepts_nested_attributes_for :users, :members

  validates :title, presence: true
  validates :description, presence: true
  validates :title, length: { maximum: 50 }
  validates :description, length: { maximum: 1500 }
  validate :assisting_limit, on: :update
 
  def assisting_limit
    errors.add(:assist_limit, "can not be lower than current assisting people") unless self.assist_limit >= assisting_people || self.assist_limit == 0
  end


  def is_full?
    self.assisting_people == self.assist_limit && self.assist_limit != 0
  end

  def is_admin?(user)
   member = Member.where(user: user, event: self).first
   member.privilege == 'admin'
  end

  def is_subadmin?(user)
    member = Member.where(user: user, event: self).first
    member.privilege == 'subadmin'
  end

  def assisting_people
    User.includes(:members).where(members: {event: self, status: 'assisting'}).count
  end

  def not_assisting_people
    User.includes(:members).where(members: {event: self, status: 'not_assisting'}).count
  end

  def pending_people
    User.includes(:members).where(members: {event: self, status: 'pending'}).count
  end


end
