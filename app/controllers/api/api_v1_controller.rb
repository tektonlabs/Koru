class Api::ApiV1Controller < ApplicationController

  protect_from_forgery with: :null_session
  rescue_from StandardError, with: :render_unknown_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

  include ApiV1ControllerHelper

  def render_unknown_error error
    response_error_json_format ErrorResponse.unknown_error(error)
  end

  def render_not_found_error error
    response_error_json_format ErrorResponse.not_found_error(error)
  end

end
