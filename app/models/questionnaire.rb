class Questionnaire < ApplicationRecord

  belongs_to :refuge
  has_many :responses
  has_many :needs

  QUESTIONS = YAML::load(File.open(File.join(Rails.root, 'config', "questions.yml")))

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
          question_answer = QuestionAnswer.find_by question_id: question_param[:id], answer_id: answers[0][:selected_id]
          unless question_answer.positive?
            set_issues self.refuge, question_param[:id]
            one_choice_register_needs question_param[:id], answers[0][:selected_id]
          end
          self.responses.build(question_id: question_param[:id], answer_selected_id: [answers[0][:selected_id]])
        end
      when :multiple_choice
        if answers.map{|a| a[:selected_id]}
          question_answer = QuestionAnswer.where question_id: question_param[:id], answer_id: answers.map{|a| a[:selected_id]}
          unless question_answer.map(&:class_type).all? {|i| i == "negative" }
            set_issues self.refuge, question_param[:id]
            multiple_choice_register_needs question_param[:id], answers.map{|a| a[:selected_id]}
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

  private

  def set_issues refuge, question_id, answer_id = nil
    entity = Question.find(question_id).entity
    refuge_entity = refuge.refuge_entities.find_by entity: (entity.second_level? ? entity.parent : entity)
    if refuge_entity
      refuge_entity.issues_number += 1
      refuge_entity.save
    end
  end

  def one_choice_register_needs question_id, answer_id
    question = Question.find_by id: question_id
    if question
      entity = question.entity.parent.nil? ? question.entity : question.entity.parent
      question_answer = QuestionAnswer.find_by question_id: question_id, answer_id: answer_id
      case question.text
      # Alimentos y agua bebible
      when "¿Hubo suficiente agua para beber y cocinar para todo el refugio?"
        if question_answer.negative?
          self.needs.build title: "No hubo suficiente agua para beber y cocinar", entity: entity
        end
      when "¿Faltaron raciones de comida?"
        if question_answer.negative?
          self.needs.build title: "Faltaron raciones de comida", entity: entity
        end
      # Salud
      when "Médicos"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia de médicos", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia de médicos", entity: entity
        end
      when "Enfermeras"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia de enfermeras", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia de enfermeras", entity: entity
        end
      when "Técnicos en salud"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia de técnicos en salud", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia de técnicos en salud", entity: entity
        end
      when "Voluntarios de salud"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia de voluntarios en salud", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia de voluntarios en salud", entity: entity
        end
      # Higiene Personal
        # No one choice questions
      # Limpieza
      when "Baños"
        if question_answer.negative?
          self.needs.build title: "Los baños están sucios", entity: entity
        end
      when "Carpas"
        if question_answer.negative?
          self.needs.build title: "Las carpas están sucias", entity: entity
        end
      when "Áreas comunes"
        if question_answer.negative?
          self.needs.build title: "Las áreas comunes están sucias", entity: entity
        end
      when "Cocina"
        if question_answer.negative?
          self.needs.build title: "La cocina está sucia", entity: entity
        end
      # Electricidad
      when "¿Tienen electricidad?"
        if question_answer.negative?
          self.needs.build title: "No hay electricidad", entity: entity
        end
      # Agua
      when "¿Tienen agua para los baños, duchas y lavanderías?"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Queda poca agua para los baños, duchas y lavandería", entity: entity
        when "negative"
          self.needs.build title: "No hay agua para los baños, duchas y lavandería", entity: entity
        end
      when "¿Tienen como almacenar el agua?"
        if question_answer.negative?
          self.needs.build title: "No hay como almacenar el agua", entity: entity
        end
      when "¿Está yendo el camión cisterna a dejar agua?"
        if question_answer.negative?
          self.needs.build title: "No está yendo el camión cisterna a dejar agua", entity: entity
        end
      # Gestion de residuos solidos
      when "¿Cuentan con basureros y puntos de acopio de basura?"
        if question_answer.negative?
          self.needs.build title: "No hay basureros o puntos de acopio de basura", entity: entity
        end
      when "¿Se está recogiendo la basura que el albergue acumula?"
        if question_answer.negative?
          self.needs.build title: "No se está recogiendo la basura que se acumula", entity: entity
        end
      when "¿Quién es el encargado del recojo de basura?"
        if question_answer.negative?
          self.needs.build title: "No hay nadie encargado del recojo de basura", entity: entity
        end
      # Seguridad
      when "¿Cómo se resolvió el incidente?"
        if question_answer.negative?
          self.needs.build title: "No se han resuelto las incidencias de seguridad", entity: entity
        end
      when "Policías"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia de policías", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia de policías", entity: entity
        end
      when "Serenazgos"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia de serenazgos", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia de serenazgos", entity: entity
        end
      when "Fuerzas armadas"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia de fuerzas armadas", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia de fuerzas armadas", entity: entity
        end
      when "Comité de seguridad"
        case question_answer.class_type
        when "middle"
          self.needs.build title: "Hubo poca presencia del comité de seguridad", entity: entity
        when "negative"
          self.needs.build title: "No hubo presencia del comité de seguridad", entity: entity
        end
      end
    end
  end

  def multiple_choice_register_needs question_id, answers_selected
    question = Question.find_by id: question_id
    if question
      entity = question.entity.parent.nil? ? question.entity : question.entity.parent
      case question.text
      # Alimentos y agua bebible
        # No multiple choice registered
      # Salud
      when "¿Se considera que algunas de estas personas deba ser evacuada por motivos de salud?"
        self.needs.build title: "Hay personas que necesitan ser evacuadas por motivos de salud", description: Answer.text_answers_selected(answers_selected), entity: entity
      when "¿Se necesita alguna de estas medicinas? (marca todas las que sean necesarias)" 
        self.needs.build title: "Se necesitan medicinas", description: Answer.text_answers_selected(answers_selected), entity: entity
      # Higiene Personal
      when "¿Se necesita alguno de estos artículos? (marca todas las que sean necesarias)"
        self.needs.build title: "Se necesitan artículos de higiene personal", description: Answer.text_answers_selected(answers_selected), entity: entity
      # Limpieza
      when "¿Qué productos de limpieza se necesita con urgencia? (marca todos los que falten)"
        self.needs.build title: "Se necesitan productos de limpieza", description: Answer.text_answers_selected(answers_selected), entity: entity
      # Electricidad
        # No multiple choice registered
      # Agua
        # No multiple choice registered
      # Gestion de residuos solidos
        # No multiple choice registered
      # Seguridad
      when "¿Se han reportado algunas de las siguientes incidencias?"
        self.needs.build title: "Se han reportado incidencias de seguridad", description: Answer.text_answers_selected(answers_selected), entity: entity
      when "¿Se han observado alguna de las siguientes situaciones de riesgo?"
        self.needs.build title: "Se han observado situaciones de riesgo", description: Answer.text_answers_selected(answers_selected), entity: entity
      end
    end

  end

end
