class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_controller

  def set_controller
    @controller = params[:controller]
  end

end
