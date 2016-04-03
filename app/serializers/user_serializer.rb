class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name


  def attributes
    data = super;
    friendship = Friendship.where(user: scope, friend: object).first
    inverse_friendship ||= Friendship.where(user: object, friend: scope).first
    if object.id != scope.id && (friendship || inverse_friendship)
      data[:type] = 'normal' if friendship
      data[:accepted] = friendship.accepted if friendship
      data[:accepted] = inverse_friendship.accepted if inverse_friendship
      data[:type] ||= 'inverse'
    end
    data
  end

end
