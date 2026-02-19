class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :age, :city_id, :description, :avatar, :remember_me ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name, :age, :city_id, :description, :avatar ])
  end

  def record_not_found
    render file: Rails.public_path.join("404.html"), layout: false, status: :not_found
  end
end
