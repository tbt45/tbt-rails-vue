module Api
  module V1
    class HealthController < ApplicationController
      def index
        render json: { status: 'ok', message: 'Rails 8 API is running!' }
      end
    end
  end
end

