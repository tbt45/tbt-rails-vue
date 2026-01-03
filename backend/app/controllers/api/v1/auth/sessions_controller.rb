module Api
  module V1
    module Auth
      class SessionsController < Api::V1::Auth::BaseController
        before_action :configure_sign_in_params, only: [:create]

        def create
          self.resource = warden.authenticate!(auth_options)
          
          if resource
            respond_with(resource)
          else
            render json: {
              status: { code: 401, message: 'Invalid email or password.' }
            }, status: :unauthorized
          end
        end

        def destroy
          # JWTトークンのリボケーションはdevise-jwtが自動的に処理
          respond_to_on_destroy
        end

        private

        def configure_sign_in_params
          devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
        end

        def respond_with(resource)
          render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: UserSerializer.new(resource)
          }, status: :ok
        end

        def resource
          @resource
        end

        def resource=(new_resource)
          @resource = new_resource
        end

        def respond_to_on_destroy
          render json: {
            status: { code: 200, message: 'Logged out successfully.' }
          }, status: :ok
        end
      end
    end
  end
end


