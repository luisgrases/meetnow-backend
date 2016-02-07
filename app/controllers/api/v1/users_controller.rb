module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json
      
      def search 
        user = current_user
        if params[:searchTerm] != ""
          results = User.search(params[:searchTerm])
        else
          results = []
        end
        all_friends = user.friends + user.inverse_friends
        final_results = results - all_friends
        if final_results.include?(user)
          final_results.delete(user);
        end
        respond_with final_results
      end

      def me
        respond_with current_user;
      end

      private

      def friendship_params
        params.require(:friendship).permit(:friend_id, :user_id, :accepted)
      end
    end
  end
end
