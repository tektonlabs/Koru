class EntitySerializer < ActiveModel::Serializer

  attributes :id, :name, :level
  has_many :questions, each_serializer: QuestionSerializer

end
