class Event < ActiveRecord::Base

  has_many :members
  has_many :users, through: :members

  accepts_nested_attributes_for :users, :members

  def attending_people
    User.includes(:members).where(members: {event: self, status: 'pending'})
  end

  def assisting_people
    User.includes(:members).where(members: {event: self, status: 'assisting'})
  end

  def not_assisting_people
    User.includes(:members).where(members: {event: self, status: 'not_assisting'})
  end
end
