class Events::ShowSerializer < EventSerializer
  root 'event'
  attributes :title, :invited_people, :admin, :invited_people_counter

  def invited_people
    result = []
    User.includes(:members).where(members: {event: object}).each do |user|
      user_member =  Member.where(event: object, user: user).first
      user_json = user.as_json
      user_json["privilege"] = user_member.privilege
      user_json["status"] = user_member.status
      result << user_json
    end
    result
  end

  def admin
    User.includes(:members).where(members: {event: object, privilege: 'admin'}).first
  end


  def invited_people_counter
    members = {
      assisting: object.assisting_people,
      not_assisting: object.not_assisting_people,
      pending: object.pending_people
    }
  end

end