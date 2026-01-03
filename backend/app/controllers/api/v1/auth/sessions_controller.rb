module Api
  module V1
    module Auth
      class SessionsController < Api::V1::Auth::BaseController
        before_action :configure_sign_in_params, only: [:create]

        def create
          email = params[:user][:email]
          password = params[:user][:password]
          
          # ユーザーを検索
          user = User.find_by(email: email)
          
          if user && user.valid_password?(password)
            # JWTトークンを生成
            token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
            
            # レスポンスヘッダーにJWTトークンを追加
            response.headers['Authorization'] = "Bearer #{token}"
            
            # 認証成功
            respond_with(user)
          else
            # 認証失敗
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


