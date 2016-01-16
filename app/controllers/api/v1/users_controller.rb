module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json
      
      def search
        user = User.find(current_user.id)
        if params[:searchTerm] != ""
          results = User.search(params[:searchTerm])
        else
          results = []
        end
        all_friends = user.friends + user.inverse_friends
        respond_with results - all_friends
      end

      private

      def friendship_params
        params.require(:friendship).permit(:friend_id, :user_id, :accepted)
      end
    end
  end
end
