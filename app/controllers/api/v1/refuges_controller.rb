class Api::V1::RefugesController < Api::ApiV1Controller

  def index
    refuges = Refuge.search_with params[:search_text]
    render json: refuges
  end

end
