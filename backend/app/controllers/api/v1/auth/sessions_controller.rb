module Api
  module V1
    module Auth
      class SessionsController < Api::V1::Auth::BaseController
        include Devise::Controllers::Helpers
        before_action :configure_sign_in_params, only: [:create]
        skip_before_action :authenticate_user!, only: [:create, :destroy]

        def create
          self.resource = warden.authenticate!(auth_options)
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          yield resource if block_given?
          respond_with(resource)
        end

        def destroy
          signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
          set_flash_message!(:notice, :signed_out) if signed_out
          yield if block_given?
          respond_to_on_destroy
        end

        private

        def configure_sign_in_params
          devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        end

        def respond_with(resource, _opts = {})
          render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: UserSerializer.new(resource)
          }, status: :ok
        end

        def respond_to_on_destroy
          if current_user
            render json: {
              status: { code: 200, message: 'Logged out successfully.' }
            }, status: :ok
          else
            render json: {
              status: { code: 401, message: "Couldn't find an active session." }
            }, status: :unauthorized
          end
        end
      end
    end
  end
end


