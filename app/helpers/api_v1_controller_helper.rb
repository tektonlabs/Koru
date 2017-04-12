module ApiV1ControllerHelper

  def response_error_json_format error_response
    render json: error_response.to_json, status: error_response.status_code
  end

end
