class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :event, touch: true

  accepts_nested_attributes_for :user, :event

end
