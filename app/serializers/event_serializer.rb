class EventSerializer < ActiveModel::Serializer
  attributes :title, :description, :updated_at, :my_privilege, :my_status, :id, :assist_limit, :status

  def my_privilege
    member = Member.where(event: object, user: scope).first
    member.privilege
  end

  def my_status
    member = Member.where(event: object, user: scope).first
    member.status
  end

end
