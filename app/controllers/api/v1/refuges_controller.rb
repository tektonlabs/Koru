class Api::V1::RefugesController < Api::ApiV1Controller

  before_action :pagination, only: :index

  def index
    refuges = Refuge.search_with(params[:query]).order(:name).limit(@limit).offset(@offset)
    render json: refuges
  end

  private

  def pagination
    @limit = params[:limit] || 15
    @offset = params[:offset] || 0
  end

end
