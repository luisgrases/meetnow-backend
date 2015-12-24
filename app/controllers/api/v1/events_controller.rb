module Api
  module V1
    class EventsController < ApplicationController
      respond_to :json
      def index
        user = User.find(current_user.id)
        respond_with user.events
      end

    end
  end
end
