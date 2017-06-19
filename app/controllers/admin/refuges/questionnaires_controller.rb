class Admin::Refuges::QuestionnairesController < AdminController

  before_action :set_refuge, only: [:new, :create]

  def new
    @questionnaire = Questionnaire.new
  end

  def create
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:refuge_id]
  end

end
