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


      private

      def event_params
        params.require(:event).permit(:title, :description, :assist_limit)
      end

    end
  end
end
