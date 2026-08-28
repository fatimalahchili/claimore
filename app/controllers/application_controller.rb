class ApplicationController < ActionController::Base
  # before every action runs, first do -> check_if_signed_in_or_redirect_to_login
  before_action :authenticate_user!

  # before every action runs, IF this is a devise controller (signup/login/etc)
  #         THEN do -> configure_permitted_parameters (defined below)
  before_action :configure_permitted_parameters, if: :devise_controller?

  # mark methods below as "internal use only" — not callable from routes/views directly
  protected

  # define a method that customizes which form fields Devise is allowed to read
  def configure_permitted_parameters
    # on the SIGN UP form specifically, ALSO allow the :name field through
    #         (by default Devise only allows email/password — this whitelists :name too)
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    #  on the EDIT PROFILE / account update form, ALSO allow :name through
    devise_parameter_sanitizer.permit(:account_update, keys:
    [:name])
  end
  private

  def available_chat_models
    RubyLLM.models.chat_models.all
           .sort_by { |model| [ model.provider.to_s, model.name.to_s ] }
  end
end
