class Api::V1::EntitiesController < Api::ApiV1Controller

  before_action :set_refuge, only: :index

  def index
    if @refuge
      entities = @refuge.entities.order(:created_at).includes(questions: [:sub_questions])
      render json: entities, each_serializer: EntitySerializer
    else
      render json: { message: "Refuge is not registered" }
    end
  end

  private

  def set_refuge
    @refuge = Refuge.find_by id: params[:refuge_id]
  end

end
