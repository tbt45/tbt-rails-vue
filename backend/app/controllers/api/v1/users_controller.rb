module Api
  module V1
    class UsersController < ApplicationController
      include Devise::Controllers::Helpers
      before_action :authenticate_user!

      def show
        render json: {
          status: { code: 200, message: 'User retrieved successfully.' },
          data: UserSerializer.new(current_user)
        }, status: :ok
      end
    end
  end
end

