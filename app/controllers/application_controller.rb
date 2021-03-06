class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :rescue_missing_params
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_bad_params

  def record_not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end

  def rescue_missing_params(exception)
    render json: { errors: [exception.message] }, status: :forbidden
  end

  def rescue_bad_params(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :forbidden
  end
end
