module Api
  module V1
    module Auth
      class RegistrationsController < Api::V1::Auth::BaseController
        before_action :configure_sign_up_params, only: [:create]

        def create
          build_resource(sign_up_params)

          if resource.save
            render json: {
              status: { code: 200, message: 'Signed up successfully.' },
              data: UserSerializer.new(resource)
            }, status: :ok
          else
            # エラーをハッシュ形式に変換
            error_hash = {}
            resource.errors.each do |error|
              error_hash[error.attribute] ||= []
              error_hash[error.attribute] << error.message
            end
            
            render json: {
              status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" },
              errors: error_hash
            }, status: :unprocessable_entity
          end
        end

        protected

        def build_resource(hash = {})
          self.resource = resource_class.new(hash)
        end

        def resource
          @resource ||= resource_class.new
        end

        def resource=(new_resource)
          @resource = new_resource
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


