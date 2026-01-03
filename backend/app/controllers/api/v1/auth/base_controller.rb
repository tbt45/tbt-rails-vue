module Api
  module V1
    module Auth
      class BaseController < ApplicationController
        include Devise::Controllers::Helpers
        respond_to :json

        protected

        def resource_name
          :user
        end

        def resource_class
          User
        end

        def auth_options
          { scope: resource_name }
        end
      end
    end
  end
end

