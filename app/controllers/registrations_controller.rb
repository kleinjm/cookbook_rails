# frozen_string_literal: true

# :nocov:
class RegistrationsController < Devise::RegistrationsController
  private

  # See https://stackoverflow.com/a/42572759/2418828
  # Code https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb#L136-L142
  def sign_up_params
    params.require(:user).
      permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :current_password
    )
  end
end
# :nocov:
