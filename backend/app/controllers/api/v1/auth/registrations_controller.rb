module Api
  module V1
    module Auth
      class RegistrationsController < Api::V1::Auth::BaseController
        include Devise::Controllers::Helpers
        before_action :configure_sign_up_params, only: [:create]
        skip_before_action :authenticate_user!, only: [:create]

        def create
          build_resource(sign_up_params)

          resource.save
          if resource.persisted?
            if resource.active_for_authentication?
              sign_up(resource_name, resource)
              render json: {
                status: { code: 200, message: 'Signed up successfully.' },
                data: UserSerializer.new(resource)
              }, status: :ok
            else
              render json: {
                status: { code: 200, message: "Signed up but #{resource.inactive_message}" },
                data: UserSerializer.new(resource)
              }, status: :ok
            end
          else
            render json: {
              status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" },
              errors: resource.errors
            }, status: :unprocessable_entity
          end
        end

        private

        def configure_sign_up_params
          devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
        end

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end


