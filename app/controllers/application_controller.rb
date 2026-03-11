class ApplicationController < ActionController::API

  before_action :authenticate_user

  private
    def authenticate_user
        header = request.headers['Authorization']
        token = header.split(' ').last if header

        @current_user = User.find_by(auth_token: token)

        unless @current_user
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
end
