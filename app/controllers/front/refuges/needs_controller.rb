class Front::Refuges::NeedsController < FrontController

  include FrontRefugesHelper

  before_action :set_refuge, only: :assign
  before_action :set_need, only: :assign

  def assign
  end

  def create
    need = Need.find params[:id]
    AssignNotificationMailer.send_notification(params[:email], date_for_needs_assign(params[:start_date], params[:end_date], params[:lonely_date]), need.title).deliver_later
    redirect_to front_refuge_path params[:refuge_id]
  end

  private

  def set_refuge
    @refuge = Refuge.find params[:refuge_id]
  end

  def set_need
    @need = Need.find params[:id]
  end

end
