require 'json'

class Event < ActiveRecord::Base

  has_many :members
  has_many :users, through: :members

  accepts_nested_attributes_for :users, :members

  validates :title, presence: true
  validates :description, presence: true
  validates :title, length: { maximum: 50 }
  validates :description, length: { maximum: 1500 }

  def invited_people
    result = []
    User.includes(:members).where(members: {event: self}).each do |user|
      user_member =  Member.where(event: self, user: user).first
      user_json = user.as_json
      user_json["privilege"] = user_member.privilege
      user_json["status"] = user_member.status
      result << user_json
    end
    result
  end

  def assisting_people
    result = []
    User.includes(:members).where(members: {event: self, status: 'assisting'}).each do |user|
      member_privilege = Member.where(event: self, user: user).first.privilege
      json = user.as_json
      json["privilege"] = member_privilege
      result << json
    end
    result
  end

  def not_assisting_people
    result = []
    User.includes(:members).where(members: {event: self, status: 'not_assisting'}).each do |user|
      member_privilege = Member.where(event: self, user: user).first.privilege
      json = user.as_json
      json["privilege"] = member_privilege
      result << json
    end
    result
  end

  def pending_people
    result = []
    User.includes(:members).where(members: {event: self, status: 'pending'}).each do |user|
      member_privilege = Member.where(event: self, user: user).first.privilege
      json = user.as_json
      json["privilege"] = member_privilege
      result << json
    end
    result
  end

  def invited_people_counter
    members = {
      assisting: self.assisting_people.count,
      not_assisting: self.not_assisting_people.count,
      pending: self.pending_people.count
    }
  end

  def is_full?
    self.assisting_people.count == self.assist_limit && self.assist_limit != 0
  end

  def admin
    User.includes(:members).where(members: {event: self, privilege: 'admin'}).first
  end

  def details
    event = {
      invited_people_counter: invited_people_counter,
      admin: admin,
      invited_people: invited_people
    }
  end


end
