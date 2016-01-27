module Api
  module V1
    class EventsController < ApplicationController
      respond_to :json
      def index
        user = User.find(current_user.id)
        respond_with user.events
      end

      def create
        user = User.find(current_user.id)
        event = Event.create(event_params)
        member = Member.create(user: user, event: event, privilege: 'admin', status: 'assisting')
        params[:users].each do |invited|
          event.users << User.find(invited["id"]);
        end
        respond_with :api, event
      end

      def invited_contacts_counter
        event = Event.find(params[:id])
        respond_with event.invited_contacts_counter
      end

      def assisting_people
        event = Event.find(params[:id])
        respond_with event.assisting_people
      end

      def not_assisting_people
        event = Event.find(params[:id])
        respond_with event.not_assisting_people
      end

      def pending_people
        event = Event.find(params[:id])
        respond_with event.pending_people
      end

      def change_member_privilege
        me_as_member = Member.where(user: current_user, event_id: params[:id]).first
        user_to_change = Member.where(user_id: params[:user_id], event_id: params[:id]).first
        if me_as_member.privilege == 'admin'
          user_to_change.privilege == 'subadmin' ? user_to_change.privilege = nil : user_to_change.privilege = 'subadmin'
          user_to_change.save
        end

        respond_with :api, user_to_change
      end


      private

      def event_params
        params.require(:event).permit(:title, :description, :assist_limit)
      end

    end
  end
end
