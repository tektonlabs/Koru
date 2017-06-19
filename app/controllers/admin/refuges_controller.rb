class Admin::RefugesController < AdminController

  before_action :set_refuge, only: [:destroy, :new_questionnaire, :create_questionnaire]

  def index
    @refuges = Refuge.search(search_params).includes(:country, :primary_contact, :questionnaires, :census_taker).order(:name).paginate(per_page: 25, page: params[:page])
  end

  def destroy
    @refuge.destroy
    redirect_to admin_root_path
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:id]
  end

  def search_params
    params.permit(:query, :dni)
  end

end
