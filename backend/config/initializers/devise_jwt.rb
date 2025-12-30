# frozen_string_literal: true

# devise-jwt configuration
Devise.setup do |config|
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key || ENV['DEVISE_JWT_SECRET_KEY'] || Rails.application.secret_key_base
    jwt.expiration_time = 1.day.to_i
    jwt.dispatch_requests = [
      ['POST', %r{^/api/v1/auth/sign_in$}],
      ['POST', %r{^/api/v1/auth/sign_up$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/api/v1/auth/sign_out$}]
    ]
  end
end

