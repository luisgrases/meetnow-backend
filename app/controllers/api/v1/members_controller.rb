module Api
  module V1
    class MembersController < ApplicationController
      respond_to :json

      private

      def member_params
        params.require(:user).permit(:id)
      end

    end
  end
end
