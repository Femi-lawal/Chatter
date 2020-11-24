# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_sign_up_params, only: [:create], if: :devise_controller?
  before_action :configure_account_update_params, only: [:update], if: :devise_controller?
  protect_from_forgery except: :callback

  rescue_from StandardError, with: :dispatch_error unless Rails.env.development?

  def dispatch_error(exception)
    case exception
    when ActiveRecord::RecordNotFound, ActionController::RoutingError
      render_404(exception)
    else
      render_500(exception)
    end
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception} #{exception.message}"
    end
    render template: "errors/error_404", status: :not_found, layout: "application"
  end

  def render_500(exception = nil)
    if exception
      logger.error "Rendering 500 with exception: #{exception.inspect}"
    end
    render template: "errors/error_500", status: :internal_server_error, layout: "application"
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :account_name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :account_name])
  end
end
