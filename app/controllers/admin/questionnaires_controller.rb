class Admin::QuestionnairesController < AdminController

  def index
    @questionnaires = Questionnaire.search(search_params).order(state_date: :desc).includes(:refuge, :user).paginate(per_page: 25, page: params[:page])
  end

  private

  def search_params
    params.permit(:refuge_id, :date, :dni)
  end

end
