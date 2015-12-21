module Api
  module V1
    class EventsController < ApplicationController
      respond_to :json
      def index
        respond_with current_user
      end

    end
  end
end
