module Api
  module V1
    class MembersController < ApplicationController
      respond_to :json
      
      def change_privilege
        #me encuentro a mi
        me = current_user
        #encuentro el event por el id del params tambien
        event = Event.find(params[:id])
        #encuentro el user por el id del params
        user = User.find(member_params)
        #encuentro el member
        member_to_change = Member.where(event: event, user: user)
        me_as_member = Member.where(event: event, user: me)
        #soy admin? si si entonces el es subadmin? si si entonces ya no, si no entoces ahora si
      
      end


      private

      def member_params
        params.require(:user).permit(:id)
      end

    end
  end
end
