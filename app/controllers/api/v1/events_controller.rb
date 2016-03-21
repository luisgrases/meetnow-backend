module Api
  module V1
    class EventsController < ApplicationController
      include ApplicationHelper

      respond_to :json
      
      def index
        render json: current_user.events
      end

      def create
        event = Event.new(event_params)
        event.members.new(user: current_user, privilege: 'admin', status: 'assisting')
        params[:users].each { |invited| event.users << User.find(invited["id"]) } if params[:users]     
        if event.save
          event.reload

          event.users.each do |member|
            event_serialized = EventSerializer.new(event, {scope: member}).as_json
            broadcast("/#{member.id}", {message: 'EVENT_INVITATION', data: event_serialized})
          end
          render json: event
        else
          render json: event.errors.full_messages, :status => 420
        end
      end

      def update
        event = Event.find(params[:id])
        if event.is_admin?(current_user)
          if event.update_attributes(event_params)
            if event.is_full?
              event.status = 'full' 
              event.save
            end
            broadcast("/#{event.id}", {message: 'EVENT_GENERAL_INFO_UPDATED', data: event})
            render json: event
          else
            render json: event.errors.full_messages, :status => 420
          end
        else
          render json: { error: 'You must be an admin to perform this operation' }, :status => 420
        end 
      end

      def invite_contact
        event = Event.find(params[:id])
        if event.is_admin?(current_user) || event.is_subadmin?(current_user)
          contact = User.find(params[:user_id])
          event.users << contact
          contact_json = contact.as_json
          contact_json["privilege"] = nil
          contact_json["status"] = 'pending'
          broadcast("/#{event.id}", {message: 'USER_INVITED', data: {event_id: event.id, user: contact_json}})
          event_serialized = EventSerializer.new(event, {scope: contact}).as_json
          broadcast("/#{contact.id}", {message: 'EVENT_INVITATION', data: event_serialized})
          render json: event
        else
          render json: event.errors.full_messages
        end
      end


      def show
        event = Event.find(params[:id])
        render json: event, serializer: Events::ShowSerializer
      end


      def change_member_privilege
        event = Event.find(params[:id])
        user = User.find(params[:user_id])
        me_as_member = Member.where(user: current_user, event: event).first
        user_to_change = Member.where(user: user, event: event).first
        if me_as_member.privilege == 'admin'
          if user_to_change.privilege != 'admin'
            if user_to_change.privilege == 'subadmin'
              user_to_change.privilege = nil
              broadcast("/#{event.id}", {message: 'USER_NOT_SUBADMIN', data: {event_id: event.id, user_id: user.id}})
            else 
              user_to_change.privilege = 'subadmin'
              broadcast("/#{event.id}", {message: 'USER_SUBADMIN', data: {event_id: event.id, user_id: user.id}})
            end
            user_to_change.save
          end
        end
        respond_with :api, user_to_change
      end

      def assist
        event = Event.find(params[:id])
        if !event.is_full?
          me_as_member = Member.where(user: current_user, event_id: params[:id]).first
          me_as_member.status = 'assisting'
          me_as_member.save 
          if event.is_full?
            event.status = 'full' 
            event.save
          end
          broadcast("/#{event.id}", {message: 'USER_ASSISTING', data: {event_id: event.id, user_id: current_user.id}})
          render json: event
        else
        render json: { error: 'Event is full' }, :status => 420
        end
      end

      def not_assist
        event = Event.find(params[:id])
        if event.is_full?
          event.status = 'open'
          event.save
        end
        me_as_member = Member.where(user: current_user, event_id: params[:id]).first
        me_as_member.status = 'not_assisting'
        me_as_member.save
        broadcast("/#{event.id}", {message: 'USER_NOT_ASSISTING', data: {event_id: event.id, user_id: current_user.id}})
        respond_with :api, me_as_member
      end

      def cancel
        event = Event.find(params[:id])
        if event.is_admin?(current_user)
          event.status = 'canceled'
          event.save
          broadcast("/#{event.id}", {message: 'EVENT_CANCELED', data: event.id})
          render json: event
        else
          render json: { error: 'You must be an admin to perform this operation' }, :status => 420
        end
      end

      def leave
        event = Event.find(params[:id])
        event.users.delete(current_user)
        broadcast("/#{event.id}", {message: 'USER_LEFT', data: {event_id: event.id, user_id: current_user.id}})
        render json: event
      end

      private

      def event_params
        params.require(:event).permit(:title, :description, :assist_limit)
      end

    end
  end
end
