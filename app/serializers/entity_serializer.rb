class EntitySerializer < ActiveModel::Serializer

  attributes :id, :name, :level
  has_many :sorted_questions, each_serializer: QuestionSerializer

  def sorted_questions
    object.questions.order(:created_at)
  end

end
