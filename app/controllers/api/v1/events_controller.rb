module Api
  module V1
    class EventsController < ApplicationController
      include ApplicationHelper

      respond_to :json
      def index
        results = []
        user = User.find(current_user.id)
        user.events.each do |event|
          member = Member.where(event: event, user: user).first
          event_json = event.as_json
          event_json["my_privilege"] = member.privilege.as_json
          event_json["my_status"] = member.status.as_json
          results << event_json
        end
        respond_with results
      end


      def create
        user = User.find(current_user.id)
        event = Event.create(event_params)
        member = Member.create(user: user, event: event, privilege: 'admin', status: 'assisting')
        if params[:users]
          params[:users].each do |invited|
            event.users << User.find(invited["id"]);
          end
        end
        broadcast("/events", {event: event})
        respond_with :api, event
      end

      def update
        #check if im admin or subadmin... for later
        event = Event.find(params[:id])
        respond_with event.update_attributes(event_params)
      end

      def invite_contact
        #check if im admin or subadmin ... for later
        event = Event.find(params[:id])
        contact = User.find(params[:user_id])
        event.users << contact
        respond_with :api, event
      end


      def show
        event = Event.find(params[:id])
        respond_with event.details
      end

      def invited_contacts_counter
        event = Event.find(params[:id])
        respond_with event.invited_contacts_counter
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

      def assist
        event = Event.find(params[:id])
        if !event.is_full?
          me_as_member = Member.where(user: current_user, event_id: params[:id]).first
          me_as_member.status = 'assisting'
          me_as_member.save
        end
        respond_with :api, me_as_member
      end

      def not_assist
        me_as_member = Member.where(user: current_user, event_id: params[:id]).first
        me_as_member.status = 'not_assisting'
        me_as_member.save
        respond_with :api, me_as_member
      end

      private

      def event_params
        params.require(:event).permit(:title, :description, :assist_limit)
      end

    end
  end
end
