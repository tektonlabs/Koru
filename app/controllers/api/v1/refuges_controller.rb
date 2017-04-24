class Api::V1::RefugesController < Api::ApiV1Controller

  def index
    refuges = Refuge.search_with params[:query]
    render json: refuges
  end

end
