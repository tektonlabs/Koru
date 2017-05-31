class Api::V1::RefugesController < Api::ApiV1Controller

  before_action :pagination, only: :index

  def index
    refuges = Refuge.search_with(search_params, @limit.to_i, @offset.to_i)
    render json: refuges
  end

  private

  def pagination
    @limit = params[:limit] || 15
    @offset = params[:offset] || 0
  end

  private

  def search_params
    params.permit(:query, :lat, :long)
  end

end
