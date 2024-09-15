class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private
  def respond_with(_resource, _opts = {})
    signin_success && return if resource.persisted?
    signin_failed
  end

  def signin_success
    render json: {
      message: "Your are logged in!",
      user: current_user
    }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user
    log_out_failure
  end

  def log_out_success
    render json: {
      message: "Logged Successfully.", status: :ok
    }
  end

  def log_out_failure
    render json: {
      message: "Logout failled.", status: :unauthorized
    }
  end
end
