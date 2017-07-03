class Admin::Refuges::QuestionnairesController < AdminController

  before_action :set_refuge, only: [:new, :create]

  def new
    @questionnaire = Questionnaire.new
    Question.all.each do |question|
      @questionnaire.responses.build question: question
    end
  end

  def create
    @questionnaire = @refuge.questionnaires.new
    @questionnaire.state_date = Time.now
    if @questionnaire.save_with_responses params[:questions].values
      @questionnaire.refuge.set_status
      redirect_to admin_refuges_path if @questionnaire.save
    else
      question_ids = @questionnaire.responses.map(&:question_id)
      Question.all.each do |question|
        @questionnaire.responses.build question: question if !question_ids.include?(question.id)
      end
      render :new
    end
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:refuge_id]
  end

end
