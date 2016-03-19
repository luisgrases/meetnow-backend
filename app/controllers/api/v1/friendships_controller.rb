module Api
  module V1
    class FriendshipsController < ApplicationController
      respond_to :json
      def index
        user = User.find(current_user.id)
        all_friends = user.friends + user.inverse_friends
        respond_with all_friends
      end

      def create
        user = User.find(current_user.id)
        friend = User.find(friendship_params[:id])
        user.friends << friend unless user.friends.include?(friend)
        respond_with :api, user
      end

      def destroy
        user = User.find(current_user.id)
        friend = user.friends.find_by_id(params[:id])
        friend ||= user.inverse_friends.find_by_id(params[:id])
        if friend
          user.friends.delete(friend)
          user.inverse_friends.delete(friend)
          render json: user
        else
          render json: { error: 'Error' }, :status => 420
        end
      end

      def accept
        user = User.find(current_user.id)
        friend = User.find(friendship_params[:id])
        friendship = Friendship.where(user: friend, friend: user).first
        friendship.accepted = true
        friendship.save
        respond_with :api, friendship
      end

      def all
        result = []
        user = User.find(current_user.id)
        user.contacts.each do |contact|
          friendship = Friendship.where(user: user, friend_id: contact['id']).first
          inverse_friendship ||= Friendship.where(user_id: contact['id'], friend: user).first
          contact_json = contact.as_json
          if friendship
            contact_json["accepted"] = friendship.accepted
            contact_json["type"] = 'normal'
          else
            contact_json["accepted"] = inverse_friendship.accepted
            contact_json["type"] = 'inverse'
          end
          result << contact_json
        end
      respond_with result
      end

      def accepted
        user = User.find(current_user.id)
        respond_with user.accepted_friends
      end

      def requests_sent
        user = User.find(current_user.id)
        respond_with user.friend_requests_sent
      end

      def requests_recieved
        user = User.find(current_user.id)
        respond_with user.friend_requests_recieved
      end

      private

      def friendship_params
        params.require(:friendship).permit(:id, :accepted, :user_id)
      end
    end
  end
end
