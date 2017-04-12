class QuestionSerializer < ActiveModel::Serializer

  attributes :id, :text, :answers, :question_type, :sub_questions
  attribute :min_text, key: :min_value
  attribute :max_text, key: :max_value

  def sub_questions
    object.sub_questions.map do |sub_question|
      SubQuestionSerializer.new(sub_question, scope: scope, root: false)
    end
  end

end
