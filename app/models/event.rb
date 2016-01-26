class Event < ActiveRecord::Base

  has_many :members
  has_many :users, through: :members

  accepts_nested_attributes_for :users, :members

  def assisting_people
    User.includes(:members).where(members: {event: self, status: 'assisting'})
  end

  def not_assisting_people
    User.includes(:members).where(members: {event: self, status: 'not_assisting'})
  end

  def pending_people
    User.includes(:members).where(members: {event: self, status: 'pending'})
  end

  def invited_contacts_counter
    members = {
      assisting: self.assisting_people.count,
      not_assisting: self.not_assisting_people.count,
      pending: self.pending_people.count
    }
  end
end
