module Api
  module V1
    class FriendshipsController < ApplicationController
      respond_to :json
      def index
        user = User.find(current_user.id)
        #friends -> i have added
        #inverse_friends -> added_me

        all_friends = user.friends + user.inverse_friends

        respond_with all_friends
      end

      def create
        user = User.find(current_user.id)
        friend = User.find(friendship_params[:id])
        user.friends << friend
        respond_with :api, user
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
        params.require(:friendship).permit(:id, :accepted)
      end
    end
  end
end
