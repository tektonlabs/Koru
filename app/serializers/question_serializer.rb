class QuestionSerializer < ActiveModel::Serializer

  attributes :id, :text, :answers, :question_type, :sub_questions
  
  def sub_questions
    object.sub_questions.map do |sub_question|
      SubQuestionSerializer.new(sub_question, scope: scope, root: false)
    end
  end

end
