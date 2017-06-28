class Admin::Refuges::QuestionnairesController < AdminController

  before_action :set_refuge, only: [:new, :create]

  def new
    @questionnaire = Questionnaire.new
    Question.all.each do |question|
      @questionnaire.responses.build question: question
    end
  end

  def create
    # ap '----------------------------------------------------'
    # ap questionnaire_params
    # ap '----------------------------------------------------'
    # questionnaire = @refuge.questionnaires.new questionnaire_params
    # questionnaire.state_date = Time.now
    # redirect_to admin_refuges_path if questionnaire.save
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:refuge_id]
  end

  def questionnaire_params
    begin
      params[:questionnaire][:responses_attributes].collect do |response|
        response[1][:answer_selected_id] = [response[1][:answer_selected_id]] if response[1][:answer_selected_id].class == String
        response[1][:answer_selected_id] = response[1][:answer_selected_id].reject(&:empty?) if response[1][:answer_selected_id]
      end
    rescue Exception => e
      Rails.logger.info "#{e}"
    end
    params.require(:questionnaire).permit(responses_attributes: [:question_id, :answer_responsed_text, answer_selected_id: []])
  end

end
