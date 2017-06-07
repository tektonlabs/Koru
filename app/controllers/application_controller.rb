class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_controller, :set_action, :set_locale

  def set_controller
    @controller = params[:controller]
  end

  def set_action
    @action = action_name
  end

  private

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options options = {}
    { locale: I18n.locale }
  end

end
