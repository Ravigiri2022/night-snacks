class MembersController < ApplicationController
  before_action :authenticate_user!

  def show
    user = get_user_from_token
    if user
      render json: {
        message: "If you see this, you're in!!",
        user: user
      }
    else
      render json: { error: "Invalid or expired token" }, status: :unauthorized
    end
  end

  private

  def get_user_from_token
    token = request.headers["Authentication"]&.split(" ")&.last
    return unless token

    begin
      jwt_payload = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload["sub"]
      User.find_by(id: user_id.to_s)
    rescue JWT::DecodeError
      nil
    end
  end
end
