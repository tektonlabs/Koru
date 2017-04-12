class SubQuestionSerializer < ActiveModel::Serializer

  attributes :id, :text, :answers, :question_type
  attribute :min_text, key: :min_value
  attribute :max_text, key: :max_value

end
