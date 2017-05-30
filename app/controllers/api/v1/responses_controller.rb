class Api::V1::ResponsesController < Api::ApiV1Controller

  before_action :set_refuge, only: :create

  def create
    questionnaire = @refuge.questionnaires.new
    if questionnaire.save_with_responses params[:questions], params[:current_date], params[:dni]
      questionnaire.refuge.set_status
      render json: { success: true }
    else
      response_error_json_format ErrorResponse.record_not_saved(questionnaire)
    end
  end

  private

  def set_refuge
    @refuge = Refuge.find_by id: params[:refuge_id]
  end

end
