class Admin::RefugesController < AdminController

  def index
    @refuges = Refuge.search(search_params).includes(:country, :primary_contact, :questionnaires).order(:name).paginate(per_page: 25, page: params[:page])
  end

  private

  def search_params
    params.permit(:query, :dni)
  end

end
