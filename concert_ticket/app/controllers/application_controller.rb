class ApplicationController < ActionController::Base
  require 'json'
  helper_method :is_user_login?
  protect_from_forgery with: :null_session
  add_flash_types :info, :error, :success, :warning
  # before_action :is_user_login?, :except => [:]
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def is_user_login?
    redirect_to login_path() if session["current_user"].blank?
  end

  def landing_page

  end
end
