class Admin::CensusTakersController < AdminController

  def index
    @census_takers = CensusTaker.search(search_params).includes(:refuges).paginate(per_page: 25, page: params[:page])
  end

  private

  def search_params
    params.permit(:dni, :phone)
  end

end
