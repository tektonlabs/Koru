class Admin::QuestionnairesController < AdminController

  def index
    @questionnaires = Questionnaire.search(search_params).includes(:refuge, :user).paginate(per_page: 5, page: params[:page])
  end

  private

  def search_params
    params.permit(:refuge, :date, :dni)
  end

end
