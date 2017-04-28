class Questionnaire < ApplicationRecord

  belongs_to :refuge
  has_many :responses

  def save_with_responses questions_params, date_param
    self.refuge.refuge_entities.update_all issues_number: 0
    self.state_date = Time.at date_param.to_i
    questions_params.each do |question|
      unless question[:sub_questions].blank?
        question[:sub_questions].each do |sub_question|
          add_response_by_question_param(sub_question) unless sub_question[:answers].blank?
        end
      end
      add_response_by_question_param(question) unless question[:answers].blank?
    end
    if self.responses.size > 0
      return self.save
    else
      self.errors.add :base, "No responses has been registered"
      return false
    end
  end

  def add_response_by_question_param question_param
    if Question.question_types.keys.include? question_param[:question_type]
      answers = question_param[:answers]
      case question_param[:question_type].to_sym
      when :one_choice
        unless answers[0][:selected_id].blank?
          if answers[0][:selected_id] != Answer.find_by(name: "Sí").id
            refuge_entity = RefugeEntity.find_by(refuge_id: self.refuge_id, entity: Question.find(question_param[:id]).entity)
            if refuge_entity
              refuge_entity.issues_number += 1
              refuge_entity.save
            end
          end
          self.responses.build(question_id: question_param[:id], answer_selected_id: [answers[0][:selected_id]])
        end
      when :multiple_choice
        if answers.map{|a| a[:selected_id]}
          refuge_entity = RefugeEntity.find_by(refuge_id: self.refuge_id, entity: Question.find(question_param[:id]).entity)
          if refuge_entity
            refuge_entity.issues_number += 1
            refuge_entity.save
          end
          self.responses.build(question_id: question_param[:id], answer_selected_id: answers.map{|a| a[:selected_id]})
        end
      when :input_value
        unless answers[0][:answer_value].blank?
          self.responses.build(question_id: question_param[:id], answer_responsed_text: answers[0][:answer_value])
        end
      end
    end
  end

end
