module Api
  module V1
    module Auth
      class BaseController < ApplicationController
        skip_before_action :verify_authenticity_token
        respond_to :json
      end
    end
  end
end

