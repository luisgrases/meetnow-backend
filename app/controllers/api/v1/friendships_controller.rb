module Api
  module V1
    class FriendshipsController < ApplicationController
      respond_to :json
      def index
        user = User.find(current_user.id)
        respond_with user.friends
      end

      def create
      end

      private

      def friendship_params
        params.require(:friendship).permit(:friend_id, :user_id, :accepted)
      end
    end
  end
end
