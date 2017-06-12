class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_controller, :set_action

  def set_controller
    @controller = params[:controller]
  end

  def set_action
    @action = action_name
  end

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end

  def after_sign_in_path_for(resource)
    admin_root_path
  end

end
