class Front::Refuges::Needs::AssignmentsController < FrontController

  before_action :set_refuge, :set_need, only: :new

  def new
    @person_in_charge = PersonInCharge.new
    @person_in_charge.engagements.build
  end

  def create
    @person_in_charge = PersonInCharge.create assignment_params
    redirect_to front_refuge_path params[:refuge_id]
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:refuge_id]
  end

  def set_need
    @need = Need.find params[:need_id]
  end

  def assignment_params
    params.require(:person_in_charge).permit(:name, :phone, :email, :organization, :responsabilities, engagements_attributes:[:start_date, :end_date, :unique_date, :need_id, :person_in_charge_id])
  end

end
