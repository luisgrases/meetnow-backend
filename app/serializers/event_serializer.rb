class EventSerializer < ActiveModel::Serializer
  attributes :title, :description, :updated_at, :id, :assist_limit, :status

  def attributes
    data = super;
    member = Member.where(event: object, user: scope).first
    if member
      data[:my_privilege] = member.privilege
      data[:my_status] = member.status
    end
    data
  end

  def my_status
    member = Member.where(event: object, user: scope).first
    member.status
  end

end
