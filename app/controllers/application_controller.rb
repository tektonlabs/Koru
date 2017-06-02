class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_controller, :set_action

  def set_controller
    @controller = params[:controller]
  end

  def set_action
    @action = action_name
  end

end
