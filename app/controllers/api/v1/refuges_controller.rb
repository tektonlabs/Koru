class Api::V1::RefugesController < Api::ApiV1Controller

  def index
    refuges = Refuge.all
    render json: refuges
  end

end
