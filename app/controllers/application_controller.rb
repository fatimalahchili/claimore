class ApplicationController < ActionController::Base
  # before every action runs, first do -> check_if_signed_in_or_redirect_to_login
  before_action :authenticate_user!, unless: :devise_controller?

  # before every action runs, IF this is a devise controller (signup/login/etc)
  #         THEN do -> configure_permitted_parameters (defined below)
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :redirect_to_www

  helper_method :current_property
  helper_method :guest_chat_session_id
  # mark methods below as "internal use only" — not callable from routes/views directly

  protected

  # define a method that customizes which form fields Devise is allowed to read
  def configure_permitted_parameters
    # on the SIGN UP form specifically, ALSO allow the :name field through
    #         (by default Devise only allows email/password — this whitelists :name too)
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :property_address, :property_moved_on])

    #  on the EDIT PROFILE / account update form, ALSO allow :name through
    devise_parameter_sanitizer.permit(:account_update, keys:
    [:name])
  end

  private

  def redirect_to_www
    if request.host == "claim-ore.de"
      redirect_to "https://www.claim-ore.de#{request.fullpath}", status: :moved_permanently, allow_other_host: true
    end
  end

  def current_property
    current_user&.properties&.first
  end

  # Stable per-browser-session identifier so a guest's chat can be found again
  # across requests without an account.
  def guest_chat_session_id
    session[:guest_chat_id] ||= SecureRandom.uuid
  end

  def available_chat_models
    RubyLLM.models.chat_models.all
           .sort_by { |model| [ model.provider.to_s, model.name.to_s ] }
  end
end
