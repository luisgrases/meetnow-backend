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
        user.friends << friend
        respond_with :api, user
      end

      def destroy
        user = User.find(current_user.id)
        friend = user.friends.find_by_id(params[:id])
        friend ||= user.inverse_friends.find_by_id(params[:id])
        user.friends.delete(friend)
        user.inverse_friends.delete(friend)
        respond_with :api, user
      end

      def accept
        user = User.find(current_user.id)
        friend = User.find(friendship_params[:id])
        friendship = Friendship.where(user: friend, friend: user).first
        friendship.accepted = true
        friendship.save
        respond_with :api, friendship
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
