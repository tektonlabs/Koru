class Questionnaire < ApplicationRecord

  belongs_to :refuge
  has_many :responses
  has_many :needs

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
          if answers[0][:selected_id] != Answer.find_by(name: "Sí").id and answers[0][:selected_id] != Answer.find_by(name: "Suficiente").id and answers[0][:selected_id] != Answer.find_by(name: "Municipalidad").id
            set_issues self.refuge, question_param[:id]
            one_choice_register_needs question_param[:id], answers[0][:selected_id]
          end
          self.responses.build(question_id: question_param[:id], answer_selected_id: [answers[0][:selected_id]])
        end
      when :multiple_choice
        if answers.map{|a| a[:selected_id]}
          set_issues self.refuge, question_param[:id]
          multiple_choice_register_needs question_param[:id], answers.map{|a| a[:selected_id]}
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

  def set_issues refuge, question_id
    refuge_entity = refuge.refuge_entities.find_by(entity: Question.find(question_id).entity)
    if refuge_entity
      refuge_entity.issues_number += 1
      refuge_entity.save
    end
  end

  def one_choice_register_needs question_id, answer_id
    question = Question.find_by id: question_id
    if question
      case question.text
      # Alimentos y agua bebible
      when "¿Hubo suficiente agua para beber y cocinar para todo el refugio?"
        self.needs.build title: "No hubo suficiente agua para beber y cocinar"
      when "¿Faltaron raciones de comida?"
        self.needs.build title: "Faltaron raciones de comida"
      # Salud
      when "Médicos"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia de médicos"
        when "No hubo"
          self.needs.build title: "No hubo presencia de médicos"
        end
      when "Enfermeras"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia de enfermeras"
        when "No hubo"
          self.needs.build title: "No hubo presencia de enfermeras"
        end
      when "Técnicos en salud"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia de técnicos en salud"
        when "No hubo"
          self.needs.build title: "No hubo presencia de técnicos en salud"
        end
      when "Voluntarios de salud"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia de voluntarios en salud"
        when "No hubo"
          self.needs.build title: "No hubo presencia de voluntarios en salud"
        end
      # Higiene Personal
        # No one choice questions
      # Limpieza
      when "Baños"
        self.needs.build title: "Los baños están sucios"
      when "Carpas"
        self.needs.build title: "Las carpas están sucias"
      when "Áreas comunes"
        self.needs.build title: "Las áreas comunes están sucias"
      when "Cocina"
        self.needs.build title: "La cocina está sucia"
      # Electricidad
      when "¿Tienen electricidad?"
        self.needs.build title: "No hay electricidad"
      # Agua
      when "¿Tienen agua para los baños, duchas y lavanderías?"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "No"
          self.needs.build title: "No hay agua para los baños, duchas y lavandería"
        when "Queda poca"
          self.needs.build title: "Queda poca agua para los baños, duchas y lavandería"
        end
      when "¿Tienen como almacenar el agua?"
        self.needs.build title: "No hay como almacenar el agua"
      when "¿Está yendo el camión cisterna a dejar agua?"
        self.needs.build title: "No está yendo el camión cisterna a dejar agua"
      # Gestion de residuos solidos
      when "¿Cuentan con basureros y puntos de acopio de basura?"
        self.needs.build title: "No hay basureros o puntos de acopio de basura"
      when "¿Se está recogiendo la basura que el albergue acumula?"
        self.needs.build title: "No se está recogiendo la basura que se acumula"
      when "¿Quién es el encargado del recojo de basura?"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Municipalidad"
          self.needs.build title: "La municipalidad"
        when "No hay nadie encargado del recojo de basura"
          self.needs.build title: "No hay nadie encargado del recojo de basura"
        end
      # Seguridad
      when "¿Cómo se resolvió el incidente?"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "No se resolvió"
          self.needs.build title: "No se resolvió"
        when "Se expulsó al agresor"
          self.needs.build title: "Se expulsó al agresor"
        when "La policía intervino"
          self.needs.build title: "La policía intervino"
        end
      when "Policías"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia de policías"
        when "No hubo"
          self.needs.build title: "No hubo presencia de policías"
        end
      when "Serenazgos"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia de serenazgos"
        when "No hubo"
          self.needs.build title: "No hubo presencia de serenazgos"
        end
      when "Fuerzas armadas"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia de fuerzas armadas"
        when "No hubo"
          self.needs.build title: "No hubo presencia de fuerzas armadas"
        end
      when "Comité de seguridad"
        answer = Answer.find_by id: answer_id
        case answer.name
        when "Poca"
          self.needs.build title: "Hubo poca presencia del comité de seguridad"
        when "No hubo"
          self.needs.build title: "No hubo presencia del comité de seguridad"
        end
      end
    end
  end

  def multiple_choice_register_needs question_id, answers_selected
    question = Question.find_by id: question_id
    if question
      case question.text
      # Alimentos y agua bebible
        # No multiple choice registered
      # Salud
      when "¿Se considera que algunas de estas personas deba ser evacuada por motivos de salud?"
        self.needs.build title: "Hay personas que necesitan ser evacuadas por motivos de salud", description: Answer.text_answers_selected(answers_selected)
      when "¿Se necesita alguna de estas medicinas? (marca todas las que sean necesarias)" 
        self.needs.build title: "Se necesitan medicinas", description: Answer.text_answers_selected(answers_selected)
      # Higiene Personal
      when "¿Se necesita alguno de estos artículos? (marca todas las que sean necesarias)"
        self.needs.build title: "Se necesitan artículos de higiene personal", description: Answer.text_answers_selected(answers_selected)
      # Limpieza
      when "¿Qué productos de limpieza se necesita con urgencia? (marca todos los que falten)"
        self.needs.build title: "Se necesitan productos de limpieza", description: Answer.text_answers_selected(answers_selected)
      # Electricidad
        # No multiple choice registered
      # Agua
        # No multiple choice registered
      # Gestion de residuos solidos
        # No multiple choice registered
      # Seguridad
      when "¿Se han reportado algunas de las siguientes incidencias?"
        self.needs.build title: "Se han reportado incidencias de seguridad", description: Answer.text_answers_selected(answers_selected)
      when "¿Se han observado alguna de las siguientes situaciones de riesgo?"
        self.needs.build title: "Se han observado situaciones de riesgo", description: Answer.text_answers_selected(answers_selected)
      end
    end

  end

end
