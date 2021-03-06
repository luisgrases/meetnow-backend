module Api
  module V1
    class FriendshipsController < ApplicationController
      include ApplicationHelper
      respond_to :json
      def index
        user = User.find(current_user.id)
        all_friends = user.friends + user.inverse_friends
        render json: all_friends
      end

      def create
        user = User.find(current_user.id)
        friend = User.find(friendship_params[:id])
        user.friends << friend unless user.friends.include?(friend)
        user_json = user.as_json
        user_json["accepted"] = false;
        user_json["type"] = 'inverse'
        broadcast("/#{friend.id}", {message: 'FRIEND_REQUEST_RECIEVED', data: user_json})
        render json: friend
      end

      def destroy
        user = User.find(current_user.id)
        friend = user.friends.find_by_id(params[:id])
        friend ||= user.inverse_friends.find_by_id(params[:id])
        if friend
          user.friends.delete(friend)
          user.inverse_friends.delete(friend)
          broadcast("/#{friend.id}", {message: 'FRIENDSHIP_REMOVED', data: user.id})
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
        broadcast("/#{friend.id}", {message: 'FRIEND_REQUEST_ACCEPTED', data: user.id})
        respond_with :api, friendship
      end

      def all
        user = User.find(current_user.id)
        all_friends = user.friends + user.inverse_friends
        all_friends.sort! { |a,b| a.name.downcase <=> b.name.downcase }
        render json: all_friends
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
