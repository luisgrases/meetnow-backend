require 'json'

class Event < ActiveRecord::Base

  has_many :members
  has_many :users, through: :members

  accepts_nested_attributes_for :users, :members


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

  def invited_contacts_counter
    members = {
      assisting: self.assisting_people.count,
      not_assisting: self.not_assisting_people.count,
      pending: self.pending_people.count
    }
  end

  def is_full?
    self.assisting_people.count == self.assist_limit
  end


end
